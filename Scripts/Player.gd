extends CharacterBody2D
class_name Player

var sword_projectile = preload("res://Scenes/player_sword_projectile.tscn")
var lazer_projectile = preload("res://Scenes/lazer_projectile.tscn")
signal health_changed

@export var max_health = 5
@export var movement_speed = 0.4
@export var wait_before_move = 0.1
@export var lazer_time = 5 ##The amount of time in the lazer state

@onready var sword_animation_player:AnimationPlayer = $SwordHitBox/AnimationPlayer
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sword:Area2D = $SwordHitBox
@onready var projectile_marker = $ProjectileMarker

const tile_size = 16
var target_position = Vector2.ZERO
var tween: Tween
var is_moving = false
var direction: float
var input_direction = Vector2.ZERO
var new_lazer: BasicProjectile
var view
var camera_pos
var bounds_bw
var bounds_fw 
var tile_position
var currect_health = max_health :
	set (value):
		currect_health = value
		currect_health = clamp(currect_health, 0, max_health)
		Globals.player_health = currect_health
		emit_signal("health_changed")
	get: 
		return currect_health

enum states {
	NORMAL,
	LAZER,
	PITFALL
}
var currect_state = states.NORMAL

@onready var collision_ray := $CollisionRay
func _ready() -> void:
	global_position = global_position.snapped(Vector2.ONE * tile_size)

func _physics_process(delta: float) -> void:
	#get the viewport size and divide by 2 since this is where the camera is positioned
	view = get_viewport_rect().size / 2

	#get the camera position
	camera_pos = get_viewport().get_camera_2d().global_position

	bounds_bw = camera_pos.y - view.y
	bounds_fw = camera_pos.y + view.y - 16

	#after the character is moved clamp its position to the end of the camera bounds
	global_position.y = clamp(global_position.y, bounds_bw, bounds_fw)

	match currect_state:
		states.NORMAL:
			normal_state()
		states.LAZER:
			lazer_state()
		states.PITFALL:
			pitfall_state(delta)

func pitfall_state(delta):
	if tween:
		tween.kill()
	#var tile_position = global_position.snapped(Vector2.ONE * tile_size)
	global_position = global_position.lerp(tile_position, 3 * delta)

func normal_state():
	get_inputs()
	if Input.is_action_just_pressed("Attack") and animation_player.is_playing():
		sword_animation_player.play("SwordAttack")
	if input_direction != Vector2.ZERO and !is_moving:
		move()

func lazer_state():
	get_inputs()
	if input_direction != Vector2.ZERO and !is_moving:
		move()
	if new_lazer != null:
		Utilities.shake_camera(1)
		return
	new_lazer = lazer_projectile.instantiate()
	add_child(new_lazer)
	await get_tree().physics_frame
	new_lazer.global_position = global_position + Vector2(0, -1)
	await get_tree().create_timer(lazer_time).timeout
	new_lazer.animation_player.play_backwards("Start")
	await new_lazer.animation_player.animation_finished
	new_lazer.queue_free()
	currect_state = states.NORMAL
func get_inputs():
	input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	input_direction = input_direction.round()
func move():
	if input_direction.x != 0 and input_direction.y != 0:
		input_direction.y = 0
	if !can_move():
		return
	is_moving = true
	animation_player.play("walk")
	target_position = (global_position + input_direction * tile_size).snapped(Vector2.ONE * tile_size)

	if target_position.y > bounds_bw and target_position.y < bounds_fw:
		tween = create_tween()
		tween.tween_property(self, "global_position", target_position, movement_speed)
		await tween.finished
		await get_tree().create_timer(wait_before_move).timeout
	is_moving = false

func can_move():
	collision_ray.target_position = input_direction * tile_size
	collision_ray.force_raycast_update()
	if collision_ray.is_colliding():
		return false
	else:
		return true

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var layer = area.collision_layer
	print(layer)
	match layer:
		8: #enemy
			take_damage(area.damage)
			print("got hit by enemy")
		32:	#Pitfall
			print("hit pit fall")
		64: #collectable
			var type = area.type
			match type:
				"Heal":
					currect_health += area.heal_amount
				"Lazer":
					currect_state = states.LAZER
					print_debug("player got the lazer power up!")
				"None":
					pass
			if area.score > 0:
				Globals.score += area.score
			area.queue_free()

func take_damage(damage_amount):
	currect_health -= damage_amount

func animation():
	pass

func spawn_sword_projectile():
	Utilities.shake_camera(0.3)
	await sword_animation_player.animation_finished
	var new_projectile = sword_projectile.instantiate()
	await get_tree().physics_frame
	new_projectile.global_position = sword.global_position
	owner.add_child(new_projectile)
func _on_hurt_box_body_entered(body: Node2D) -> void:
	var layer = body
	print(layer)
	if layer is TileMap:
		var local_position = layer.local_to_map(global_position)
		tile_position = layer.map_to_local(local_position).snapped(Vector2.ONE * tile_size)
		print(tile_position.snapped(Vector2.ONE * tile_size))
		currect_state = states.PITFALL
func disable_player():
	pass

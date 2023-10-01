extends CharacterBody2D
class_name Player

var sword_projectile = preload("res://Scenes/player_sword_projectile.tscn")
var lazer_projectile = preload("res://Scenes/lazer_projectile.tscn")
signal health_changed

@export var max_health = 5
@export var movement_speed = 0.4
@export var wait_before_move = 0.1
@export var lazer_time = 5 ##The amount of time in the lazer state

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sword:Area2D = $SwordHitBox
@onready var projectile_maker = $ProjectileMarker

const tile_size = 16
var target_position = Vector2.ZERO
var tween: Tween
var is_moving = false
var direction: float
var input_direction = Vector2.ZERO
var new_lazer: BasicProjectile
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
}
var currect_state = states.NORMAL

@onready var collision_ray := $CollisionRay
func _ready() -> void:
	global_position = global_position.snapped(Vector2.ONE * tile_size)

func _physics_process(delta: float) -> void:
	match currect_state:
		states.NORMAL:
			normal_state()
		states.LAZER:
			lazer_state()

func normal_state():
	get_inputs()
	if Input.is_action_just_pressed("Attack"):
		animation_player.play("SwordAttack")
	if input_direction != Vector2.ZERO and !is_moving:
		move()

func lazer_state():
	get_inputs()
	if input_direction != Vector2.ZERO and !is_moving:
		move()
	if new_lazer != null:
		return
	new_lazer = lazer_projectile.instantiate()
	add_child(new_lazer)
	await get_tree().physics_frame
	new_lazer.global_position = global_position
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
	target_position = global_position + input_direction * tile_size
	target_position = round(target_position)

	#target_position.y = clamp(target_position.y, -72, 56)

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

func spawn_sword_projectile():
	animation_player.stop()
	var new_projectile = sword_projectile.instantiate()
	new_projectile.global_position = sword.global_position - Vector2(0, 16)
	owner.add_child(new_projectile)

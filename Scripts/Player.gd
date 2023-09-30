extends CharacterBody2D
class_name Player

var sword_projectile = preload("res://Scenes/player_sword_projectile.tscn")

signal health_changed

@export var max_health = 5
@export var movement_speed = 0.4
@export var wait_before_move = 0.1

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sword:Area2D = $SwordHitBox

const tile_size = 16
var target_position = Vector2.ZERO
var tween: Tween
var is_moving = false
var direction: float
var currect_health = max_health :
	set (value):
		currect_health = value
		Globals.player_health = currect_health
		emit_signal("health_changed")
	get: 
		return currect_health

@onready var collision_ray := $CollisionRay
func _ready() -> void:
	global_position = global_position.snapped(Vector2.ONE * tile_size)

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("Left", "Right")

	if Input.is_action_just_pressed("Attack"):
		animation_player.play("SwordAttack")
	if direction != 0 and !is_moving:
		move()


func move():
	if !can_move():
		return
	is_moving = true
	target_position.x = global_position.x + direction * tile_size
	target_position.x = round(target_position.x)

	tween = create_tween()
	tween.tween_property(self, "global_position:x", target_position.x, movement_speed)
	await tween.finished
	await get_tree().create_timer(wait_before_move).timeout
	is_moving = false

func can_move():
	collision_ray.target_position.x = direction * tile_size
	collision_ray.force_raycast_update()
	if collision_ray.is_colliding():
		return false
	else:
		return true

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var layer = area.collision_layer
	print(layer)
	match layer:
		4: #enemy
			take_damage(area.damage)
		32:	#Pitfall
			print("hit pit fall")
		
	
	
	

func take_damage(damage_amount):
	currect_health -= damage_amount

func spawn_sword_projectile():
	animation_player.stop()
	var new_projectile = sword_projectile.instantiate()
	new_projectile.global_position = sword.global_position - Vector2(0, 16)
	owner.add_child(new_projectile)

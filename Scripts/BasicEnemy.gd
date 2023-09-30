extends CharacterBody2D
class_name BasicEnemy

@export var currect_health := 1
@export var damage := 1
@export var can_move := false
@export var move_wait_time = 3
@export var enemyScore = 10


@onready var area_hitbox = $HitBox
@onready var collision_ray := $CollisionRay
@onready var movement_timer := $MovementChanceTimer
var timer
var direction = Vector2.ZERO
var target_position = Vector2.ZERO

func _ready() -> void:
	area_hitbox.damage = damage

func take_damage(damage_amount):
	currect_health -= damage_amount

	if currect_health <= 0:
		dealth()
func dealth():
	queue_free()
func move():
	target_position.x = global_position.x + direction * 16

	var tween = create_tween()
	tween.tween_property(self, "global_position:x", target_position.x, 0.6)
	await tween.finished

func _on_hurtbox_area_entered(area:Area2D) -> void:
	take_damage(area.damage)

func check_direction(direction):
	collision_ray.target_position.x = direction * 16
	collision_ray.force_raycast_update()
	if collision_ray.is_colliding():
		return false
	else:
		return true

func _on_movement_chance_timer_timeout() -> void:
	print("test timer")
	var chance = randi_range(1, -1)
	if chance == 0:
		return
	if check_direction(chance):
		direction = chance
		move()
	else:
		direction = -chance

	

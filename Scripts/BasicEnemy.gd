extends CharacterBody2D
class_name BasicEnemy

@export var currect_health := 1
@export var damage := 1
@export var can_move := false
@export var move_wait_time = 3
@export var enemyScore = 10
@export_enum("NONE", "SIDE", "SHOOT", "CICLE") var ai_type := "NONE"

@onready var area_hitbox = $HitBox
@onready var collision_ray := $CollisionRay
@onready var animation_player = $AnimationPlayer
var timer
var tween
var direction = Vector2(-1, -1)
var target_position = Vector2.ZERO

func _ready() -> void:
	area_hitbox.damage = damage

	match ai_type:
		"NONE":
			pass
		"SIDE":
			side_state()
		"SHOOT":
			pass
		"CICLE":
			pass
func side_state():
	await get_tree().create_timer(2).timeout
				
	print("123")
	direction.y = 0
	direction.x = -direction.x
	move()

	
func take_damage(damage_amount):
	currect_health -= damage_amount

	if currect_health <= 0:
		dealth()
func dealth():
	Globals.score += enemyScore
	animation_player.play("Death")
	await animation_player.animation_finished
	queue_free()
func move():
	if tween != null:
		return

	print("____")
	target_position = global_position + direction * 16
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.6)
	await tween.finished

func _on_hurtbox_area_entered(area:Area2D) -> void:
	take_damage(area.damage)
	print(area.name)
func _physics_process(delta: float) -> void:
	pass

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

	

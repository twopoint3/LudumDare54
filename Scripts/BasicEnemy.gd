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

@export var projectile:PackedScene
var timer
var tween
var direction = Vector2(-1, -1)
var target_position = Vector2.ZERO
var i = 0
func _ready() -> void:
	area_hitbox.damage = damage

	match ai_type:
		"NONE":
			pass
		"SIDE":
			side_state()
		"SHOOT":
			shoot_state()
		"CICLE":
			cicle_state()
func side_state():
	await get_tree().create_timer(2).timeout
				
	direction.y = 0
	direction.x = -direction.x
	move()
	side_state()
func shoot_state():
	var new_p = projectile.instantiate()
	await get_tree().physics_frame
	new_p.global_position = global_position
	owner.add_child(new_p)

	await get_tree().create_timer(2.5).timeout
	shoot_state()
func cicle_state():
	await get_tree().create_timer(2).timeout
	var move = [Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0), Vector2(0, -1)]

	direction = move[i]
	i += 1
	move()
	if i > 3:
		i = 0
	
	cicle_state()
	
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
	if check_direction(direction) == false:
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
	collision_ray.target_position = direction * 16
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

	

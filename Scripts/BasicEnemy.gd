extends CharacterBody2D
class_name BasicEnemy

@export var currect_health := 1
@export var damage := 1
@export var can_move := false
@export var move_wait_time = 3
@export var enemyScore = 10
@export_enum("NONE", "SIDE", "SHOOT", "CICLE") var ai_type := "NONE"
@export var fire_speed = 2.5
@onready var area_hitbox = $HitBox
@onready var collision_ray := $CollisionRay
@onready var animation_player = $AnimationPlayer
@onready var damage_sound = $DamageSound

@export var projectile:PackedScene
var timer
var tween
var is_died := false
var direction = Vector2(-1, -1)
var target_position = Vector2.ZERO
var i = 0
func _ready() -> void:
	area_hitbox.damage = damage
func side_state():
	await get_tree().create_timer(2).timeout
				
	direction.y = 0
	direction.x = -direction.x
	move()
	side_state()
func shoot_state():
	if is_died == true:
		return
	await time(fire_speed)
	print("1")
	var new_p = projectile.instantiate()
	await get_tree().physics_frame
	new_p.global_position = global_position
	owner.add_child(new_p)
	return

func time(time):
	await get_tree().create_timer(time).timeout

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
	damage_sound.play()

	if currect_health <= 0:
		dealth()
func dealth():
	Globals.score += enemyScore
	is_died = true
	animation_player.play("Death")
	await animation_player.animation_finished
	queue_free()
func move():
	if tween != null:
		return
	if check_direction(direction) == false:
		return
	target_position = global_position + direction * 16
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, 0.6)
	await tween.finished

func _on_hurtbox_area_entered(area:Area2D) -> void:
	take_damage(area.damage)
	print(area.name)

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


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	match ai_type:
		"NONE":
			pass
		"SIDE":
			side_state()
		"SHOOT":
			shoot_state()
		"CICLE":
			cicle_state()

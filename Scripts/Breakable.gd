extends Area2D

@export var health = 1
@export var item_dropped:Array[PackedScene] = []
@export var drop_chance = 1.0
@export var score = 5
@onready var animation_player = $AnimationPlayer
@onready var pot_break = $PotBreak
@onready var collision = $CollisionShape2D

func _on_area_entered(area:Area2D) -> void:
	health -= area.damage
	pot_break.play()

	if health <= 0:
		death()
func drop_item():
	if item_dropped.size() <= 1:
		spawn_item(item_dropped[0])
	else:
		var rand_item = randi_range(0, item_dropped.size())
		spawn_item(item_dropped[rand_item])

		
func chance():
	var random = randf()
	print(random)
	if drop_chance >= random:
		return true
	else:
		return false

func death():
	collision.disabled = true
	Globals.score += score
	animation_player.play("Death")
	await animation_player.animation_finished
	if chance():
		drop_item()
	call_deferred("queue_free")
func spawn_item(item):
	var new_item = item.instantiate()
	new_item.global_position = global_position
	owner.call_deferred("add_child", new_item)

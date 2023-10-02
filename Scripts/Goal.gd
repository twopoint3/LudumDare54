extends Area2D

signal player_reached_goal
@onready var animation_player = $AnimationPlayer
@onready var front_door = $FrontOfDoor
@export var next_level: PackedScene

func _on_area_entered(area:Area2D) -> void:
	emit_signal("player_reached_goal")

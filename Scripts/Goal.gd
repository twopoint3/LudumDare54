extends Area2D

signal player_reached_goal

func _on_area_entered(area:Area2D) -> void:
	emit_signal("player_reached_goal")

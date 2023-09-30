extends Area2D

var damage = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = global_position.snapped(Vector2.ONE * 16)
	connect("area_entered", _on_area_entered)

func _on_area_entered(area:Area2D) -> void:
	pass
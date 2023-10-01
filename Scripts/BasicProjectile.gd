extends Area2D
class_name BasicProjectile

@export var damage := 1
@export var speed = 120
@export var pierce := false

@export var direction = Vector2(0, -1)

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	global_position = global_position.snapped(Vector2.ONE * 16)

func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO or speed == 0:
		return
	global_position += direction * speed * delta

func _on_area_entered(area:Area2D) -> void:
	if pierce == true:
		return
	queue_free()

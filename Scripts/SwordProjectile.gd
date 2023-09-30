extends BasicProjectile

#@export var damage := 1
#@export var speed = 120
#@export var pierce := false

#var direction = Vector2(0, -1)

#func _ready() -> void:
#	global_position = global_position.snapped(Vector2.ONE * 16)

#func _physics_process(delta: float) -> void:
#	global_position += direction * speed * delta

#func _on_area_entered(area:Area2D) -> void:
#	if pierce == true:
#		return
#	queue_free()

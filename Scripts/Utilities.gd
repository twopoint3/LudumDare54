extends Node

var camera: Camera2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shake_camera(strength: float):
	camera.shake_strength = strength
func stop_camera():
	camera.stop_camera_movement()
func resume_camera_movement():
	camera.resume_camera_movement()
extends Camera2D

@export var target = Node2D
@export var speed = 25
@export var starting_speed = speed
var shake_strength = 0
var tween:Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target == null:
		print_debug("camera target not set")
	Utilities.camera = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, 4 * delta)

		offset = camera_shake()
	
func stop_camera_movement():
	speed = 0
func resume_camera_movement():
	speed = starting_speed
func _physics_process(delta: float) -> void:
	if speed > 0:
		global_position.y -= speed * delta
func wait_then_start_moving(time):
	var timer = get_tree().create_timer(time)
	await timer.timeout
	resume_camera_movement()


func camera_shake():
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))

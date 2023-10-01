extends Camera2D

@export var target = Node2D
@export var speed = 25
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
	

func _physics_process(delta: float) -> void:
	global_position.y -= speed * delta

func camera_shake():
	return Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))

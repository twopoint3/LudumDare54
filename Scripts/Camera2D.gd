extends Camera2D

@export var target = Node2D
@export var speed = 25
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target == null:
		print_debug("camera target not set")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	global_position.y -= speed * delta
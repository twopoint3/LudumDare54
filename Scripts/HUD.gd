extends CanvasLayer

@onready var health_bar = $HUDControl/HealthBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_health_bar(value: int):
	health_bar.value = value
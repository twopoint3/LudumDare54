extends CanvasLayer

@onready var health_bar = $HUDControl/HealthBar
@onready var score_text = $HUDControl/Score
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_health_bar(value: int):
	health_bar.value = value
func set_score(value):
	score_text.text = str(value).pad_zeros(3)
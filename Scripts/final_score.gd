extends Control

@onready var final_text:Label = $ScoreLabel
var menu = load("res://Scenes/Main_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	final_text.text = "Final Score " + str(Globals.real_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		LevelChanger.change_level("Fade", menu)
		Globals.score = 0
		Globals.real_score = 0

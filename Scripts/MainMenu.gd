extends Control


var level_1 = load("res://Scenes/level_1.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var opening_animation_length := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opening_animation_length = animation_player.get_animation("Opening").length
	animation_player.play("Opening")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack") and !animation_player.is_playing():
		LevelChanger.change_level("Fade", level_1)
func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		skip_opening()

func skip_opening():
	animation_player.seek(opening_animation_length, true)


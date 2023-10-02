extends Control


var level_1 = load("res://Scenes/level_1.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var opening_animation_length := 0
@export var music:AudioStreamMP3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicController.play_music(music)
	opening_animation_length = animation_player.get_animation("Opening").length
	animation_player.play("Opening")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack") and !animation_player.is_playing():
		LevelChanger.change_level("Fade", level_1)
	if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Escape"):
		skip_opening()
func skip_opening():
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	animation_player.seek(opening_animation_length, true)


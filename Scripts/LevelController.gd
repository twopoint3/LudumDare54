extends Node2D

@onready var player:Player = get_tree().get_first_node_in_group("Player")

@onready var hud := $HUD
@onready var goal = $Environment/Goal
@onready var scoreText:Label = $HUD/HUDControl/Score
@export var wait_camera := 1
@export var music:AudioStreamMP3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.real_score = Globals.score
	if music != null:
		MusicController.play_music(music)
	player.connect("health_changed", player_health_changed)
	goal.connect("player_reached_goal", player_reached_end)
	Globals.connect("score_changed", hud_update_score.bind((Globals.score)))

	hud_update_score(Globals.score)
	Utilities.camera_wait_then_start(wait_camera)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_health_changed():
	hud_update_health_bar()

func hud_update_health_bar():
	hud.set_health_bar(player.currect_health)
func player_reached_end():
	Globals.real_score = Globals.score
	print("end")
func hud_update_score(score: int):
	hud.set_score(Globals.score)

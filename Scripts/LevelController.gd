extends Node2D

@onready var player:Player = get_tree().get_first_node_in_group("Player")

@onready var hud := $HUD
@onready var goal = $Environment/Goal
@onready var scoreText:Label = $HUD/HUDControl/Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("health_changed", player_health_changed)
	goal.connect("player_reached_goal", player_reached_end)
	Globals.connect("score_changed", hud_update_score.bind((Globals.score)))

	hud_update_score(Globals.score)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func player_health_changed():
	hud_update_health_bar()

func hud_update_health_bar():
	hud.set_health_bar(player.currect_health)
func player_reached_end():
	print("end")
func hud_update_score(score: int):
	hud.set_score(Globals.score)

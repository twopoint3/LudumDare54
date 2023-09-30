extends Control

signal half_way
@onready var animation_player:AnimationPlayer = $AnimationPlayer

func animation_half_way():
	emit_signal("half_way")

func change_level(transition_type:String, level_pack:PackedScene):

	animation_player.play(transition_type)
	await half_way
	get_tree().change_scene_to_packed(level_pack)
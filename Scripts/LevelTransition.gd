extends CanvasLayer

signal half_way
@onready var animation_player:AnimationPlayer = $Control/AnimationPlayer

func animation_half_way():
	emit_signal("half_way")

func change_level(transition_type:String, level_pack:PackedScene):
	animation_player.play(transition_type)
	await half_way
	get_tree().change_scene_to_packed(level_pack)
func restart_level(transition_type:String):
	animation_player.play(transition_type)
	await half_way
	get_tree().reload_current_scene()

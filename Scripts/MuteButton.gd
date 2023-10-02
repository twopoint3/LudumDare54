extends TextureButton

@onready var texture = $TextureRect
func _on_pressed() -> void:
	print("pressed")
	if MusicController.volume == 1:
		MusicController.musicOff()
		texture.texture = load("res://Sprites/HUD/SpeakerOff.png")

	else:
		MusicController.musicOn()
		texture.texture = load("res://Sprites/HUD/SpeakerOn.png")


func _on_toggled(button_pressed: bool) -> void:
	print("123123")

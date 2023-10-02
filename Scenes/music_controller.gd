extends Node
@onready var music:AudioStreamPlayer = $Musicbox

var volume = 1
func musicOff():
	volume = 0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))
func musicOn():
	volume = 1
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))

func play_music(track:AudioStreamMP3):
	if music.playing:
		music.stop()
	music.stream = track
	music.play()
func stop_music():
	music.stop()

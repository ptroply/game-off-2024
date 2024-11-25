extends AudioStreamPlayer

func set_music(path : String):
	var new_audio : AudioStream = load(str("res://Music/", path, "_wav.tres"))
	if !new_audio.resource_name.match(stream.resource_name):
		stop()
		stream = new_audio
		play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()


func _on_finished() -> void:
	play()

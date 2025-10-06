extends CanvasLayer

func _on_button_pressed() -> void:
	var i = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(i, not AudioServer.is_bus_mute(i))

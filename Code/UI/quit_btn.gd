extends Button


func _pressed() -> void:
	Audio.stop_music()
	Signals.ToggleControl.emit("main_menu", true, "result_screen")

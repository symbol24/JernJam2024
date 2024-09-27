extends Button


func _pressed() -> void:
	Signals.ToggleControl.emit("main_menu", true, "result_screen")

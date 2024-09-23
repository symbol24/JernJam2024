extends Button


func _pressed() -> void:
	Game.pause_tree(true)
	Signals.ToggleControl.emit("dialogue", true, "main_menu")
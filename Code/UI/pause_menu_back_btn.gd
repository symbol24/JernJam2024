extends Button


func _pressed() -> void:
	Signals.ToggleControl.emit("player_ui", true, "pause_menu")
	Game.pause_tree(false)
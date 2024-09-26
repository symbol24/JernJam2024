class_name PauseMenu extends SyControl


func _input(_event: InputEvent) -> void:
	if UI.can_pause:
		if visible and Input.is_action_just_pressed("pause"):
			print("should unpause!")
			Game.pause_tree(false)
			Signals.ToggleControl.emit(UI.last_menu, true, "pause_menu")
		elif not visible and Input.is_action_just_pressed("pause"):
			print("should pause!")
			Game.pause_tree(true)
			Signals.ToggleControl.emit("pause_menu", true, UI.current_menu)
class_name PauseListener extends SyAction


func _input(_event: InputEvent) -> void:
	if not get_tree().paused and Input.is_action_just_pressed("pause"):
		_toggle_pause()


func _toggle_pause() -> void:
	Signals.ToggleControl.emit("pause_menu", true, "player_ui")
	Game.pause_tree(true)
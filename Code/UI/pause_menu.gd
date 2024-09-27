class_name PauseMenu extends SyControl


@onready var pause_menu_tab_container:TabContainer = %pause_menu_tab_container


var current:int = 0:
	set(value):
		current = value
		if current >= pause_menu_tab_container.get_tab_count():
			current = 0
		elif current < 0:
			current = pause_menu_tab_container.get_tab_count()

func _input(_event: InputEvent) -> void:
	if UI.can_pause:
		if visible and Input.is_action_just_pressed("pause"):
			#print("should unpause!")
			Signals.ToggleControl.emit("player_ui", true, "pause_menu")
			Game.pause_tree(false)
		elif not visible and Input.is_action_just_pressed("pause"):
			#print("should pause!")
			Game.pause_tree(true)
			Signals.ToggleControl.emit("pause_menu", true, "player_ui")

	if get_tree().paused:
		if Input.is_action_just_pressed("tab_left"):
			current -= 1
			pause_menu_tab_container.current_tab = current
		if Input.is_action_just_pressed("tab_right"):
			current += 1
			pause_menu_tab_container.current_tab = current

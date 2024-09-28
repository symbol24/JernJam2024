extends CanvasLayer


var current_menu:String = ""
var last_menu:String = ""
var controls:Array[SyControl] = []
var can_pause:bool:
	get:
		return current_menu != "dialogue" and current_menu != "loading" and Game.active_level != null
var mouse_countdown:bool = false
var mouse_delay:float = 5
var mouse_timer:float = 0.0:
	set(value):
		mouse_timer = value
		if mouse_timer >= mouse_delay:
			mouse_timer = 0.0
			mouse_countdown = false
			_toggle_mouse(false)


func _ready() -> void:
	Signals.ToggleControl.connect(_toggle_control)
	controls = _get_controls()


func _process(delta: float) -> void:
	if mouse_countdown: mouse_timer += delta


func _toggle_control(_id:String, _visible:bool = true, _from:String = "") -> void:
	for each in controls:
		if each.id == _id:
			current_menu = _id
			each.set_deferred("visible", _visible)
			if _visible: each.play_entry()
		else:
			if _visible: each.set_deferred("visible", false)
	
	if _from: last_menu = _from

	match _id:
		"player_ui": 
			mouse_countdown = true
		"main_menu", "pause_menu", "result_screen", "dialogue":
			_toggle_mouse(true)
		

func _get_controls() -> Array[SyControl]:
	var children = get_children()
	var result:Array[SyControl] = []
	for child in children:
		if child is SyControl:
			result.append(child)
	return result


func _toggle_mouse(_on:bool = true) -> void:
	if _on: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
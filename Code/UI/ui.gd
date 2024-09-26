extends CanvasLayer


var current_menu:String = ""
var last_menu:String = ""
var controls:Array[SyControl] = []
var can_pause:bool:
	get:
		return current_menu != "dialogue" and current_menu != "loading" and Game.active_level != null


func _ready() -> void:
	Signals.ToggleControl.connect(_toggle_control)
	controls = _get_controls()


func _toggle_control(_id:String, _visible:bool = true, _from:String = "") -> void:
	for each in controls:
		if each.id == _id:
			current_menu = _id
			each.set_deferred("visible", _visible)
		else:
			if _visible: each.set_deferred("visible", false)
	
	if _from: last_menu = _from


func _get_controls() -> Array[SyControl]:
	var children = get_children()
	var result:Array[SyControl] = []
	for child in children:
		if child is SyControl:
			result.append(child)
	return result

class_name SyButton extends Button


enum Btn_Type {
				LEVEL = 0,
				MENU = 1,
			}

@export var destination:String
@export var btn_type:Btn_Type

var parent_menu:String = ""


func _ready() -> void:
	var sycontrol:SyControl = get_parent() as SyControl
	if sycontrol != null:
		parent_menu = sycontrol.id


func _pressed() -> void:
	match btn_type:
		Btn_Type.LEVEL:
			Signals.LoadLevel.emit(destination)
		Btn_Type.MENU:
			Signals.ToggleControl.emit(destination, true, parent_menu)

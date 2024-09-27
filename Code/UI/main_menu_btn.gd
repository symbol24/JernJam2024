class_name MainMenuButton extends TextureButton


enum Btn_Type {
				LEVEL = 0,
				MENU = 1,
			}

@export var destination:String
@export var btn_type:Btn_Type
@export var parent:SyControl
@export var audio:String

var parent_menu:String = ""


func _ready() -> void:
	if parent != null: parent_menu = parent.id
	else: push_warning("Button ", name, " does not have an assigned parent menu.")
	parent.visibility_changed.connect(_grab_focus)


func _grab_focus() -> void:
	if parent and parent.visible:
		grab_focus()


func _pressed() -> void:
	Signals.SkipMainMenuMusic.emit()
	if audio:
		Audio.play_audio(DataManager.get_audio_file(audio))
	match btn_type:
		Btn_Type.LEVEL:
			Signals.LoadLevel.emit(destination)
		Btn_Type.MENU:
			Signals.ToggleControl.emit(destination, true, parent_menu)
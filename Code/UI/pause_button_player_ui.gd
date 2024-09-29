class_name PauseButton extends TextureButton


@export var key_texture:CompressedTexture2D
@export var gamepad_texture:CompressedTexture2D

@onready var key_text:RichTextLabel = %key_text


func _ready() -> void:
	Signals.ControlSwitch.connect(_switch_texture)


func _switch_texture(_type:Game.CONTROLS) -> void:
	match _type:
		Game.CONTROLS.MOUSE_KEYBOARD:
			texture_normal = key_texture
			key_text.show()
		Game.CONTROLS.GAMEPAD:
			texture_normal = gamepad_texture
			key_text.hide()
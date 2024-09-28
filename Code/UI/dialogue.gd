class_name Dialogue extends SyControl


@onready var skip_button:Button = %skip_button


func play_entry() -> void:
	if skip_button: skip_button.grab_focus()
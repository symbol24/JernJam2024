extends Button



func _pressed() -> void:
	Signals.DisplayText.emit(DataManager.lorem_ipsum)
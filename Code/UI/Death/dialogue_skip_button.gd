extends Button


func _pressed() -> void:
	Signals.SkipDialogue.emit()
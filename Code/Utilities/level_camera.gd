class_name LevelCamera extends Camera2D


func _ready() -> void:
	Signals.MoveCamera.connect(_move_to)


func _move_to(_position:Vector2, _time:float) -> void:
	var tween:Tween = self.create_tween()
	tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "global_position", _position, _time)
	await tween.finished
	Signals.CameraInPosition.emit()

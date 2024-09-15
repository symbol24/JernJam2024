class_name Room extends Node2D



func _ready() -> void:
	Signals.RoomReady.emit(self)

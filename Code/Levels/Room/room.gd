class_name Room extends Node2D


@export var entrance_spawn_point:Marker2D
@export var camera_point:Marker2D


func _ready() -> void:
	#print("Room ", name, " ready function")
	if entrance_spawn_point == null: push_error("Room ", name, " does not have a spawn point marker2d.")
	if camera_point == null: push_error("Room ", name, " does not have a camera point marker2d.")
	var level:Level = get_parent() as Level
	level.room_ready(self)

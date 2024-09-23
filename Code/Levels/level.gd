class_name Level extends Node2D

@export var id:String = ""
@export var camera:LevelCamera
@export var enemy_spawner:EnemySpawner

var player:SyCharacterBody2D
var rooms:Array = []
var confirmed_rooms:Array[Room] = []
var active_room_id:int = 0
var active_room:Room:
	get:
		if rooms.is_empty(): return null
		return rooms[active_room_id]


func _ready() -> void:
	Signals.TransitionToNextRoom.connect(_switch_active_room)
	Signals.CameraInPosition.connect(_camera_in_room)
	if camera == null: push_error("Camera missing from level ", id)
	rooms = get_tree().get_nodes_in_group("room")
	_all_rooms_ready()


func room_ready(_room:Room) -> void:
	confirmed_rooms.append(_room)


func _set_player(_player:SyCharacterBody2D) -> void:
	player = _player
	print("Player ", player.data.id, " received.")


func _all_rooms_ready() -> void:
	if confirmed_rooms.size() == rooms.size():
		Signals.InstantiateLevelEnemies.emit(confirmed_rooms)
		player = Game.get_character()
		add_child(player)
		player.global_position = active_room.entrance_spawn_point.global_position
		Signals.MoveCamera.emit(active_room.camera_point.global_position, 0)
		Signals.LevelReady.emit(self)
		Signals.ToggleControl.emit("player_ui", true)
		Signals.RoomEntered.emit(active_room.room_type)


func _switch_active_room() -> void:
	Game.pause_tree(true)
	active_room_id += 1
	if active_room_id >= rooms.size(): 
		push_error("Trying to get a room past the room count.")
		active_room_id = rooms.size() - 1
	Signals.MoveCamera.emit(active_room.camera_point.global_position, Game.CAMERA_TRANSITION_TIME)
	player.global_position = active_room.entrance_spawn_point.global_position


func _camera_in_room() -> void:
	Signals.RoomEntered.emit(active_room.room_type)
	Game.pause_tree(false)

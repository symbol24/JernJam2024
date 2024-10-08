class_name Level extends Node2D

@export var id:String = ""
@export var camera:LevelCamera
@export var enemy_spawner:EnemySpawner
@export var enemy_waves:Array[SpawnerData] = []

var data:LevelData
var player:SyCharacterBody2D
var rooms:Array = []
var active_room_id:int = 0
var active_room:Room:
	get:
		#print("rooms: ", rooms)
		if rooms.is_empty(): return null
		return rooms[active_room_id]


func _ready() -> void:
	Signals.TransitionToNextRoom.connect(_switch_active_room)
	Signals.CameraInPosition.connect(_camera_in_room)
	Signals.RoomEntered.connect(_play_music)
	if camera == null: push_error("Camera missing from level ", id)
	if get_tree().get_first_node_in_group("generator") == null: push_error("Map Generator scene missing from level tree.")
	

func room_ready(_room:Room) -> void:
	rooms.append(_room)


func all_rooms_ready() -> void:
	if rooms.size() == 2:
		Signals.InstantiateLevelEnemies.emit(self)
		player = Game.get_character()
		add_child.call_deferred(player)
		await player.ready
		player.global_position = active_room.entrance_spawn_point.global_position
		Signals.MoveCamera.emit(active_room.camera_point.global_position, 0)
		Signals.LevelReady.emit(self)
		Signals.ToggleControl.emit("player_ui", true)
		Signals.RoomEntered.emit(active_room.room_type)


func get_combat_room() -> RoomData:
	for each:RoomData in data.rooms:
		if each.type == Room.Room_Type.COMBAT: return each
	return null


func get_shop_room() -> RoomData:
	for each:RoomData in data.rooms:
		if each.type == Room.Room_Type.SHOP: return each
	return null



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


func _play_music(_room_type:Room.Room_Type) -> void:
	match _room_type:
		Room.Room_Type.COMBAT:
			var file_name:String
			if data.id.contains("fantasy"):
				file_name = "fantasy"
			elif data.id.contains("modern"):
				file_name = "modern"
			Audio.play_audio(DataManager.get_audio_file(file_name+"_music"))
		_:
			Audio.play_audio(DataManager.get_audio_file("shop_music"))
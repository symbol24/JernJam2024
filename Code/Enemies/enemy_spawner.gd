class_name EnemySpawner extends Node2D


const SPAWN_AREA = [72, 252, 24, 156]
const GOBLIN = preload("res://Data/EnemyDatas/goblin.tres")


var active_room:Room
var spawn_active:bool = false


func _ready() -> void:
	Signals.RoomReady.connect(_set_room)


func _set_room(_room:Room) -> void:
	if _room:
		active_room = _room

extends Node

const CHARACTER_DATA = preload("res://Data/main_character.tres")

# Damage constants
const MAX_CC:float = 0.8
const OVERFLOW_PERCENTAGE:float = 1.0

var selected_data:CharacterData = CHARACTER_DATA

var active_room:Room

# A quick variable to check if the tree is paused.
var is_paused:bool:
	get:
		return get_tree().paused
		
#Levels and loading
var active_level:Node
var is_loading := false
var to_load := ""
var load_complete := false
var loading_status := 0.0
var progress := []
var extra_loading := false


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.RoomReady.connect(_set_active_room)


func get_closest_between(_object:Node2D, _list:Array) -> Node2D:
	if _object and not _list.is_empty():
		var closest = _list[0]
		var last_check = _object.global_position.distance_squared_to(closest.global_position)
		for each in _list:
			var check = _object.global_position.distance_squared_to(each.global_position)
			if check < last_check: 
				closest = each
				last_check = check
		return closest
	push_error("_get_closest_between was sent faulty parameters")
	return null


func _set_active_room(_room:Room) -> void:
	active_room = _room

extends Node2D


@export var character_datas:Array[CharacterData] = []
@export var levels:LevelLoadData
@export var shop_item:PackedScene
@export var damage_number:PackedScene
@export var hp_heart:PackedScene
@export var item_label:PackedScene
@export var dialogue_lists:Array[DialogueData]
@export var room_list:Array[RoomData]
@export var generic_level:PackedScene


func get_dialogue(_id:String) -> String:
	for each in dialogue_lists:
		if each.id == _id:
			return each.get_next()
	return "[list not found]"


func get_room_path(_room_name:String) -> String:
	#print("receiving room name: ", _room_name)
	for each in room_list:
		if _room_name == each.id:
			#print(" returning room path: ", each.path)
			return each.path
	return ""
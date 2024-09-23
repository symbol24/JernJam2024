extends Node2D


@export var character_datas:Array[CharacterData] = []
@export var levels:LevelLoadData
@export var shop_item:Resource
@export var damage_number:Resource
@export var hp_heart:Resource
@export var dialogue_lists:Array[DialogueData]


func get_dialogue(_id:String) -> String:
	for each in dialogue_lists:
		if each.id == _id:
			return each.get_next()
	return "[list not found]"



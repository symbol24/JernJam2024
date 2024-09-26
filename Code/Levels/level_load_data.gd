class_name LevelLoadData extends Resource

@export var levels:Dictionary
@export var loading_delay:float = 1
@export var level_datas:Array[LevelData] = []


func get_level_data(_id) -> LevelData:
	if has_level(_id):
		for level in level_datas:
			if level.id == _id: return level
	return null


func has_level(_id:String) -> bool:
	for level in level_datas:
		if level.id == _id: return true
	return false
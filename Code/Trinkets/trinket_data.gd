class_name TrinketData extends Resource


const MAX_LEVEL:int = 4

@export var id:String = ""
@export var icon_path:String = ""
@export var level_json:String = ""

var level:int = 1:
	set(value):
		level = value
		if level > MAX_LEVEL:
			level = MAX_LEVEL
var level_data:Dictionary


func get_level_data_for(_variable:String = "") -> float:
	var currentlevel:String = "level"+str(level)
	if level_data.has(currentlevel) and level_data[currentlevel].has(_variable):
		return float(level_data[currentlevel][_variable])
	return 0


func parse_level_data() -> void:
	level_data = Game.parse_json_data(level_json)


func get_value_of(_variable:String) -> float:
	if level_data.has("level"+str(level)):
		var ld:Dictionary = level_data["level"+str(level)]
		if ld.has(_variable):
			return float(ld[_variable])
	return 0.0
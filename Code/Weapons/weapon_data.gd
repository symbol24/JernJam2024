class_name WeaponData extends Resource

enum Target_Type {
					NONE = 0,
					CLOSEST = 1,
					RANDOM_IN_RANGE = 2,
					RANDOM_ANYWHERE = 3,
					CLOSEST_IN_RANGE = 4,
					RANDOM_POSITION_ON_MAP = 5,
					SELF = 6,
				}


@export var id:String = ""
@export var weapon_path:String = ""
@export var projectile_path:String = ""
@export var icon_path:String = ""
@export var target_type:Target_Type
@export var level:int = 1
@export var level_json:String = ""
@export var trigger_delay:float = 1.0:
	get:
		var result = get_level_data_for("trigger_delay")
		if result != 0:
			return result
		return trigger_delay
@export var shoot_delay:float = 0.1:
	get:
		var result = get_level_data_for("shoot_delay")
		if result != 0:
			return result
		return shoot_delay
@export var projectile_count:float = 1.0:
	get:
		var result = get_level_data_for("projectile_count")
		if result != 0:
			return result
		return projectile_count
@export var damages:Array[Damage] = []
@export var projectile_life_time:float = 0.5:
	get:
		var result = get_level_data_for("projectile_life_time")
		if result != 0:
			return result
		return projectile_life_time
@export var projectile_scale:float = 1:
	get:
		var result = get_level_data_for("projectile_scale")
		if result != 0:
			return result
		return projectile_scale
@export var remain_on_player:bool = false
@export var extras:Dictionary = {}

var level_data:Dictionary


func parse_level_data() -> void:
	var file = FileAccess.open(level_json, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var result = json.parse(json_string)
		if result != OK:
			push_error("Weapon data level json parsing failed for ", id)
			return
		
		level_data = json.data.duplicate()
		file.close()


func get_level_data_for(_variable:String = "") -> float:
	var currentlevel:String = "level"+str(level)
	if level_data.has(currentlevel) and level_data[currentlevel].has(_variable):
		return float(level_data[currentlevel][_variable])
	return 0
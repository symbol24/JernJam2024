class_name WeaponData extends Resource

enum Target_Type {
					NONE = 0,
					CLOSEST = 1,
					RANDOM_IN_RANGE = 2,
					RANDOM_ANYWHERE = 3,
					CLOSEST_IN_RANGE = 4,
					RANDOM_POSITION_ON_MAP = 5,
				}


@export var id:String = ""
@export var weapon_path:String = ""
@export var projectile_path:String = ""
@export var icon_path:String = ""
@export var target_type:Target_Type
@export var level:int = 1
@export var level_json:String = ""
@export var trigger_delay:float = 1.0
@export var shoot_delay:float = 0.1
@export var projectile_count:float = 1.0
@export var damages:Array[Damage] = []
@export var projectile_life_time:float = 0.5:
	get:
		return projectile_life_time + (level*0.5)
@export var projectile_scale:float = 1:
	get:
		return 1 + (level*0.5)
@export var extras:Dictionary = {}

var level_data:Dictionary = {}


func parse_level_data() -> void:
	var file = FileAccess.open(level_json, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var result = json.parse(json_string)
	if result != OK:
		push_error("Weapon data level json parsing failed for ", id)
		return
	
	level_data = json.data
	print(level_data)
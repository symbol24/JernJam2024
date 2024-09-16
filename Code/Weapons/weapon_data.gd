class_name WeaponData extends Resource

enum Target_Type {
					NONE = 0,
					CLOSEST = 1,
					RANDOM_IN_RANGE = 2,
					RANDOM_ANYWHERE = 3,
					CLOSEST_IN_RANGE = 4,
				}


@export var id:String = ""
@export var weapon_path:String = ""
@export var projectile_path:String = ""
@export var target_type:Target_Type
@export var trigger_delay:float = 1.0
@export var shoot_delay:float = 0.1
@export var projectile_count:float = 1.0
@export var damages:Array[Damage] = []

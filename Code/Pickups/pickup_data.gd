class_name PickupData extends Resource

enum Type {
			SPECIAL = 0,
			CURRENCY = 1,
			HEALTH = 2,
			EMPTY = 3,
		}

@export var id:String = ""
@export var type:Type = Type.EMPTY
@export var value:int = 0
@export var scene_path:String = ""

class_name SpawnerData extends Resource

const SPAWN_AREA = [72, 252, 24, 156]

@export var id:String = "":
	get:
		if id == "": return resource_name
		return id
@export var is_triggered_spawn:bool = true
@export var delay_before_starting:float = 0.0
@export var spawn_amount:int = 1
@export var spawn_delay_between:float = 1.0
@export var enemies_to_spawn:Array[EnemyData]
@export var spawn_area:Array[float] = [72, 252, 24, 156]:
	get:
		var to_return:Array[float] = spawn_area
		if to_return.size() != 4:
			push_error("Spawn area of ", id, " SpawnerData is not 4 numbers.")
			return [72, 252, 24, 156]
		else:
			var error:bool = false
			if to_return[0] < SPAWN_AREA[0]: 
				to_return[0] = SPAWN_AREA[0]
				error = true
			if to_return[1] > SPAWN_AREA[1]: 
				to_return[1] = SPAWN_AREA[1]
				error = true
			if to_return[2] < SPAWN_AREA[2]: 
				to_return[2] = SPAWN_AREA[2]
				error = true
			if to_return[3] > SPAWN_AREA[3]: 
				to_return[3] = SPAWN_AREA[3]
				error = true
			if error: push_error("Spawn area of ", id, " SpawnerData contains values not in ", SPAWN_AREA, ". Values returned clamped.")
		
		return to_return
		

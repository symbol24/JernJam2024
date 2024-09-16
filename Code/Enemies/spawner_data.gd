class_name SpawnerData extends Resource

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
			if to_return[0] < 72: 
				to_return[0] = 72
				error = true
			if to_return[1] > 252: 
				to_return[0] = 252
				error = true
			if to_return[2] < 24: 
				to_return[0] = 24
				error = true
			if to_return[3] > 156: 
				to_return[0] = 156
				error = true
			if error: push_error("Spawn area of ", id, " SpawnerData contains values not in [72, 252, 24, 156]. Values returned clamped.")
		
		return to_return
		

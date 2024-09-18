class_name CombatRoom extends Room

@export var spawn_list:Array[SpawnerData] = []
@export var enemy_spawner:EnemySpawner


func _ready() -> void:
	super()
	if spawn_list.is_empty(): push_error("Room ", name, " spawn_list is empty, nothing to spawn.")

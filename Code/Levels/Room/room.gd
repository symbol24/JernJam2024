class_name Room extends Node2D

@export var spawn_list:Array[SpawnerData] = []
@export var enemy_spawner:EnemySpawner

func _ready() -> void:
	Signals.RoomReady.emit(self)
	Signals.ToggleControl.emit("player_ui", true)
	if spawn_list.is_empty(): push_error("Room ", name, " spawn_list is empty, nothing to spawn.")
	elif not spawn_list.is_empty() and spawn_list[0].is_triggered_spawn:
		Signals.SpawnNextWave.emit()
	

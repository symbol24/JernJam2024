class_name EnemySpawner extends Node2D


@onready var room:Room = get_parent() as Room

# Spawning
var spawn_active:bool = false
var active_spawn_id:int = 0:
	set(_value):
		active_spawn_id = _value
		if active_spawn_id >= room.spawn_list.size(): 
			spawn_active = false
			print("Spawn over")
		else: 
			_start_next_spawn_data(room)
			
var instantiated_enemies:Array[Enemy2D] = []
var enemy_pool:Array[Array] = []
var all_enemies:Array[Enemy2D] = []
var wave_count:int = 0:
	set(_value):
		wave_count = _value
		if wave_count >= room.spawn_list[active_spawn_id].spawn_amount:
			wave_count = 0
			spawn_timer_active = false
			active_spawn_id += 1
var enemy_total_spawn_count:int = 0

# Spawn Timers
var spawn_timer_active:bool = false
var spawn_delay:float = 0.0
var spawn_timer:float = 0.0:
	set(_value):
		spawn_timer = _value
		if spawn_timer >= spawn_delay:
			spawn_timer = 0.0
			spawn_timer_active = false
			_spawn_wave(active_spawn_id)

var wait_next_spawn_timer_active:bool = false
var wait_next_spawn_delay:float = 0.0
var wait_next_spawn_timer:float = 0.0:
	set(_value):
		wait_next_spawn_timer = _value
		if wait_next_spawn_timer >= wait_next_spawn_delay:
			wait_next_spawn_timer = 0.0
			wait_next_spawn_timer_active = false
			_spawn_wave(active_spawn_id)


func _ready() -> void:
	Signals.SpawnNextWave.connect(_start_next_spawn_data)
	Signals.ReturnEnemyToPool.connect(_return_to_pool)
	if not room.is_node_ready(): await room.ready
	
	# instantiting one of each enemy
	for spawn_data in room.spawn_list:
		for each:EnemyData in spawn_data.enemies_to_spawn:
			if _check_is_not_instantiated(each, instantiated_enemies):
				var new_enemy:Enemy2D = load(each.path).instantiate() as Enemy2D
				instantiated_enemies.append(new_enemy)


func _physics_process(_delta: float) -> void:
	if wait_next_spawn_timer_active: wait_next_spawn_timer += _delta
	if spawn_timer_active: spawn_timer += _delta


func _spawn_wave(_id:int) -> void:
	if spawn_active:
		var spawn_data:SpawnerData = room.spawn_list[_id]
		if spawn_data != null:
			for enemy:EnemyData in spawn_data.enemies_to_spawn:
				var new_enemy = _get_instantiated_enemy(enemy, instantiated_enemies)
				room.add_child(new_enemy)
				new_enemy.name = enemy.id + str(enemy_total_spawn_count)
				new_enemy.set_data(new_enemy.name)
				new_enemy.set_level(Game.active_level.player.data.level)
				new_enemy.global_position = Vector2(randf_range(spawn_data.spawn_area[0], spawn_data.spawn_area[1]), randf_range(spawn_data.spawn_area[2], spawn_data.spawn_area[3]))
				all_enemies.append(new_enemy)
				enemy_total_spawn_count += 1
				
			spawn_delay = spawn_data.spawn_delay_between
			spawn_timer_active = true
			wave_count += 1


func _start_next_spawn_data(_room:Room) -> void:
	if _room == room:
		spawn_active = true
		wait_next_spawn_delay = room.spawn_list[active_spawn_id].delay_before_starting
		wait_next_spawn_timer_active = true


func _get_instantiated_enemy(_data:EnemyData, _list:Array[Enemy2D]) -> Enemy2D:
	for enemy in _list:
		if enemy.enemy_data.id == _data.id:
			return enemy.duplicate()
	return null


func _check_is_not_instantiated(_data:EnemyData, _list:Array[Enemy2D]) -> bool:
	for each in enemy_pool:
		if not each.is_empty() and each[0].data.id == _data.id:
			return each.pop_front()

	for each in _list:
		if each.data == _data:
			return false
		elif each.enemy_data == _data:
			return false
	return true


func _remove_enemy_from_all(_enemy:Enemy2D) -> void:
	all_enemies.erase(_enemy)
	if not spawn_active and all_enemies.is_empty():
		Signals.RoomClear.emit()


func _return_to_pool(_enemy:Enemy2D) -> void:
	for each in enemy_pool:
		if each.has(_enemy):
			_remove_enemy_from_all(_enemy)
			return
			
	for each in enemy_pool:
		if not each.is_empty() and each[0].data.id == _enemy.data.id:
			each.append(_enemy)
			_remove_enemy_from_all(_enemy)
			return
	
	_remove_enemy_from_all(_enemy)
	enemy_pool.append([_enemy])

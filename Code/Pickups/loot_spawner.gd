class_name LootSpawner extends Node


@onready var player:SyCharacterBody2D = get_tree().get_first_node_in_group("player") as SyCharacterBody2D

var pool_of_items:Array[Array] = []


func _ready() -> void:
	Signals.SpawnLoot.connect(_spawn_loot)
	Signals.PickupReturnToPool.connect(_return_to_pool)


func _spawn_loot(_position:Vector2, _loot_table:LootTable) -> void:
	#print("spawning loot at ", _position)
	var loot:Array = _loot_table.get_loot()
	
	var p:int = 0
	var positions:Array[Vector2] = [
									_position, 
									Vector2(_position.x + 12, _position.y),
									Vector2(_position.x, _position.y+12),
									Vector2(_position.x - 12, _position.y),
									Vector2(_position.x, _position.y - 12),
									]
	for each in loot:
		if each.type != PickupData.Type.EMPTY:
			if each.scene_path == "":
				push_error("Missing path for ", each.id, " in loot table ", _loot_table.id)
				continue
			var new_loot:PickupItem = _get_item_to_spawn(each)
			add_child.call_deferred(new_loot)
			new_loot.set_pickup.call_deferred(each, self, player)
			new_loot.spawn_pickup.call_deferred(positions[p])
			
			p += 1
			if p >= positions.size(): p = 0


func _get_item_to_spawn(_data:PickupData) -> PickupItem:
	for pool in pool_of_items:
		if not pool.is_empty() and pool[0].pickup_data.id == _data.id:
			return pool.pop_front()
	
	return load(_data.scene_path).instantiate() as PickupItem


func _return_to_pool(_item:PickupItem) -> void:
	for pool in pool_of_items:
		if not pool.is_empty() and pool[0].pickup_data.id == _item.pickup_data.id:
			pool.append(_item)
			return
	pool_of_items.append([_item])
			

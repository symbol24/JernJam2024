class_name LootTable extends Resource


@export var id:String
@export var loot_amount:int = 1
@export var items:Array[Dictionary] = []


func get_loot(_amount:int = loot_amount, _data:CharacterData = null) -> Array:
	var result:Array = []
	var total_weight:int = _get_total_weight(items)
	var weighted_table:Array[Dictionary] = _weight_table(items.duplicate(true))
	var i:int = 0
	while i < _amount:
		var weight:int = randi_range(0, total_weight) # TODO: replace with rng seeded in Game when done
		var choice:Dictionary
		var found:bool = false
		for item in weighted_table:
			if not found and weight <= item["weight"]:
				var skip:bool = false
				if item["data"] is ShopItemData:
					if item["data"].weapon_data:
						var wd:WeaponData = _data.get_weapon_data(item["data"].weapon_data.id)
						if wd:
							#print("Weapon level of ", wd.id, " ", wd.level)
							if wd.level == WeaponData.MAX_LEVEL:
								#print("weapon ", wd.id, " should be skipped")
								skip = true
					if item["data"].trinket_data:
						var td:TrinketData = _data.get_trinket_data(item["data"].trinket_data.id)
						if td:
							if td.level == TrinketData.MAX_LEVEL:
								#print("trinket ", td.id, " should be skipped")
								skip = true
				if skip:
					continue
				else:
					choice = item.duplicate(true)
					found = true
				
		if choice.has("data"):
			result.append(choice["data"])
			i += 1
		else: push_error(choice, " does not have a proper dictionary setup in loot table ", id)
		
	return result
	

func _get_total_weight(_list:Array[Dictionary] = []) -> int:
	if not _list.is_empty():
		var total:int = 0
		for item in _list:
			if item.has("weight"):
				total += item["weight"]
		return total
	return -1


func _weight_table(_table:Array[Dictionary]) -> Array[Dictionary]:
	var total:int = 0
	for item in _table:
		total += item["weight"]
		item["weight"] = total
	return _table


func _print_table(_table:Array[Dictionary]) -> void:
	for each in _table:
		print(each["data"].id, ": ", each["weight"])
	print("----------")

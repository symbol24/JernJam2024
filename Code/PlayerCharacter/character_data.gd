class_name CharacterData extends BaseCharacterData


@export var base_range:float = 1.0
@export var starting_weapon:String
@export var character_sprite:String

var range_percent:float:
	set(value):
		range_percent = value
		Signals.UpdateCharacterRange.emit(range_percent, range_flat)
var range_flat:float = 0:
	set(value):
		range_flat = value
		Signals.UpdateCharacterRange.emit(range_percent, range_flat)
var coins:int = 0:
	set(value):
		coins = value
		Signals.CoinsUpdated.emit(coins)

var weapon_data:WeaponData
var trinkets:Array[TrinketData] = []
var weapons:Array[WeaponData] = []


func setup_data(_owner:CharacterBody2D) -> void:
	current_hp = base_hp
	max_hp = base_hp
	range_percent = base_range
	coins = 0
	level = 1
	Signals.ConstructHP.emit(self)
	if _owner != null: data_owner = _owner
	else: push_error("Character ", id, " receiving a null owner in set_data.")
	weapon_data = load(starting_weapon)
	trinkets.clear()


func reset_data() -> void:
	current_hp = base_hp
	max_hp = base_hp
	bonus_hp = 0
	range_percent = base_range
	range_flat = 0
	coins = 0
	level = 1
	bonus_speed = 0
	weapon_data = load(starting_weapon)
	trinkets.clear()
	weapons.clear()
	Signals.ResetPlayerUi.emit()
	

func heal(_amount:int = 0) -> void:
	current_hp += _amount
	Signals.DamageReceived.emit(data_owner, _amount, Damage.Type.HEAL)


func add_trinket(_data:TrinketData) -> void:
	for each in trinkets:
		if each.id == _data.id:
			each.level += 1
			return

	var new_data:TrinketData = _data.duplicate()
	new_data.parse_level_data()
	trinkets.append(new_data)
	Signals.UpdateUiWithTrinket.emit(_data)


func get_trinket_value_of(_variable:String) -> float:
	for trinket in trinkets:
		if trinket.get_value_of(_variable) != 0.0:
			return trinket.get_value_of(_variable)
	return 0.0


func receive_damage(_damages:Array[Damage]) -> void:
	#print(id, " has received damages: ", _damages)
	for dmg_data in _damages:
		var damage:Damage = dmg_data.get_damage()
		var final_damage:int = damage.final_damage
		match damage.type:
			Damage.Type.PHYSICAL:
				final_damage -= armor + int(get_trinket_value_of("armor"))
			Damage.Type.MAGICAL:
				final_damage -= shield
			_:
				pass
		if final_damage < 0: final_damage = 0
		#print("Final damage: ",final_damage)
		current_hp -= final_damage
		Signals.DamageReceived.emit(data_owner, final_damage)

func add_weapon_data(_data:WeaponData) -> void:
	weapons.append(_data)


func get_weapon_data(_id:String) -> WeaponData:
	for each in data_owner.weapons:
		if each.data.id == _id:
			return each.data
	return null


func get_trinket_data(_id:String) -> TrinketData:
	for each in trinkets:
		if each.id == _id:
			return each
	return null


func is_weapon_max_level(_id:String) -> bool:
	if not weapons.is_empty():
		for each in weapons:
			if each.id == _id:
				print("weapon chech, each.level: ", each.level)
				return each.level == WeaponData.MAX_LEVEL
	return false


func is_trinket_max_level(_id:String) -> bool:
	if not trinkets.is_empty():
		for each in trinkets:
			if each.id == _id:
				print("trinket chech, each.level: ", each.level)
				return each.level == TrinketData.MAX_LEVEL
	return false
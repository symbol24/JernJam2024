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


func heal(_amount:int = 0) -> void:
	current_hp += _amount
	Signals.DamageReceived.emit(data_owner, _amount, Damage.Type.HEAL)

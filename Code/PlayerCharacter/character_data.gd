class_name CharacterData extends BaseCharacterData

@export var base_range:float = 1.0

var range_percent:float:
	set(value):
		range_percent = value
		Signals.UpdateCharacterRange.emit(range_percent, range_flat)
var range_flat:float = 0:
	set(value):
		range_flat = value
		Signals.UpdateCharacterRange.emit(range_percent, range_flat)


func setup_data(_owner:CharacterBody2D) -> void:
	current_hp = base_hp
	max_hp = base_hp
	range_percent = base_range
	Signals.ConstructHP.emit(max_hp)
	if _owner != null: data_owner = _owner
	else: push_error("Character ", id, " receiving a null owner in set_data.")

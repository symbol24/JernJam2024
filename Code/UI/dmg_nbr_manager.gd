class_name DmgNumbManager extends Control


var dmg_nbr:DamageNumberRTL
var pool:Array[DamageNumberRTL] = []


func _ready() -> void:
	Signals.DamageReceived.connect(_display_dmg_nmbrs)
	dmg_nbr = DataManager.damage_number.instantiate()


func _display_dmg_nmbrs(_character:CharacterBody2D, _damage:int, _type:Damage.Type = Damage.Type.PHYSICAL, _is_critical:bool = false) -> void:
	var new:DamageNumberRTL = _get_dmg_nbr()
	add_child.call_deferred(new)
	var variation:String = _get_variation(_type, _is_critical)
	new.set_damage_number.call_deferred(str(_damage), variation, 15, 0.5)
	var pos:Vector2 = Vector2(_character.global_position.x - 4, _character.global_position.y - 6)
	new.set_deferred("global_position", Game.active_level.active_room.to_local(pos))
	new.display_number.call_deferred()


func _get_dmg_nbr() -> DamageNumberRTL:
	if pool.is_empty():
		return dmg_nbr.duplicate()
	
	return pool.pop_front()


func _get_variation(_type:Damage.Type, _is_critical:bool) -> String:
	var result:String = ""
	
	match _type:
		Damage.Type.PHYSICAL:
			result = "PhysicalCrit" if _is_critical else "Physical"
		Damage.Type.MAGICAL:
			result = "MagicalCrit" if _is_critical else "Magical"
		Damage.Type.HEAL:
			result = "HealCrit" if _is_critical else "Heal"
		_:
			result = "DamageNumberRTL"
	
	return result

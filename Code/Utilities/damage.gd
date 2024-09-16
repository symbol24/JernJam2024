class_name Damage extends Resource

enum Type {
			NONE = 0,
			PHYSICAL = 1,
			MAGICAL = 2,
			HEAL = 3,
			}

@export var base_damage:int = 0
@export var type:Type
@export var crit_chance:float = 0.0
@export var crit_bonus:float = 0.0

var damage_owner:BaseCharacterData
var final_damage:int = 0
var is_critical:bool = false


func set_owner(_owner:BaseCharacterData) -> void:
	if _owner: damage_owner = _owner


func get_damage() -> Damage:
	if damage_owner != null:
		final_damage = base_damage
		var cc:float = crit_chance + damage_owner.crit_chance
		var cb:float = crit_bonus + damage_owner.crit_bonus
		var overflow:float = 0.0
		if cc > Game.MAX_CC:
			overflow = cc - Game.MAX_CC
			cc = Game.MAX_CC
			cb += overflow * Game.OVERFLOW_PERCENTAGE
		if crit_chance > 0.0:
			var chance:float = randf_range(0,1)
			if chance <= cc:
				is_critical = true
				final_damage = ceili(final_damage * cb)
	else:
		push_error("Damage ", resource_name, " has no owner. No final damage calculated")
	
	return self

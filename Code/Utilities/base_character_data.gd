class_name BaseCharacterData extends Resource

@export var id:String = ""
@export var base_hp:int = 1
@export var speed:float = 50
@export var armor:int = 0
@export var shield:int = 0
@export var crit_chance:float = 0.0
@export var crit_bonus:float = 0.0

var data_owner:CharacterBody2D
var current_hp:int = 1:
	set(value):
		current_hp = value
		#print("current_hp of ", id, " is ", current_hp)
		Signals.HpUpdated.emit(self)
		if current_hp <= 0:
			current_hp = 0
			Signals.CharacterDefeated.emit(self)
		elif current_hp > max_hp: current_hp = max_hp
		
var max_hp:int


func setup_data(_owner:CharacterBody2D) -> void:
	current_hp = base_hp
	max_hp = base_hp
	if _owner != null: data_owner = _owner
	else: push_error("Character ", id, " receiving a null owner in set_data.")


func receive_damage(_damages:Array[Damage]) -> void:
	#print(id, " has received damages: ", _damages)
	for dmg_data in _damages:
		var damage:Damage = dmg_data.get_damage()
		var final_damage:int = damage.final_damage
		match damage.type:
			Damage.Type.PHYSICAL:
				final_damage -= armor
			Damage.Type.MAGICAL:
				final_damage -= shield
			_:
				pass
		if final_damage < 0: final_damage = 0
		#print("Final damage: ",final_damage)
		current_hp -= final_damage
		Signals.DamageReceived.emit(data_owner, final_damage)

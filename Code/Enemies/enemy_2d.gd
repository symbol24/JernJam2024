class_name Enemy2D extends CharacterBody2D

@export var enemy_data:EnemyData

var data:EnemyData
var attack_areas:Array[AttackArea] = []


func _ready() -> void:
	Signals.CharacterDefeated.connect(_enemy_defeated)


func set_data(_name:String) -> void:
	data = enemy_data.duplicate()
	data.setup_data(self)
	data.set_damage_owner()
	attack_areas = _get_attack_areas()
	data.hash_id = hash(_name)


func _physics_process(_delta: float) -> void:
	
	
	move_and_slide()


func set_level(_level:int = 1) -> void:
	data.level = _level


func set_velocity_by_move(_new_velocity:Vector2) -> void:
	velocity = _new_velocity


func _get_attack_areas() -> Array[AttackArea]:
	var children = get_children()
	var attacks:Array[AttackArea] = []
	for child in children:
		if child is AttackArea:
			attacks.append(child)
			child.set_contact_damages()
	return attacks


func _enemy_defeated(_data:BaseCharacterData) -> void:
	if _data is EnemyData and _data.hash_id == data.hash_id:
		Signals.SpawnLoot.emit(global_position, data.loot_table.duplicate())
		get_parent().remove_child.call_deferred(self)
		Signals.ReturnEnemyToPool.emit(self)

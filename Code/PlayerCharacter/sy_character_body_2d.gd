class_name SyCharacterBody2D extends CharacterBody2D


@onready var character_range: Area2D = %character_range

var data:CharacterData
var enemies_in_range:Array[Enemy2D] = []
var weapons:Array[Weapon] = []
var trinkets:Array = []

func _ready() -> void:
	character_range.body_entered.connect(_range_body_entered)
	character_range.body_exited.connect(_range_body_exited)
	Signals.CollectItem.connect(_collect_item)
	#print("selected character: ", data.id)
	#print("Starter weapon: ", data.starting_weapon)
	_build_character(data)
	Signals.PlayerReady.emit(self)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func set_velocity_by_move(_new_velocity:Vector2) -> void:
	velocity = _new_velocity


func _build_character(_data:CharacterData) -> void:
	_data.setup_data(self)
	construct_weapon(_data.weapon_data)
	var new_sprite:Node2D = load(_data.character_sprite).instantiate() as Node2D
	add_child.call_deferred(new_sprite)
	new_sprite.position = Vector2(-6, -6)


func _range_body_entered(_body) -> void:
	if _body is Enemy2D:
		enemies_in_range.append(_body as Enemy2D)


func _range_body_exited(_body) -> void:
	if _body is Enemy2D:
		enemies_in_range.erase(_body)


func _collect_item(_data:PickupData) -> void:
	match _data.type:
		PickupData.Type.SPECIAL:
			pass
		PickupData.Type.CURRENCY:
			data.coins += _data.value
		PickupData.Type.HEALTH:
			data.heal(_data.value)
		_:
			pass


func construct_weapon(_data:WeaponData) -> void:
	#print("weapond data received: ", _data)
	if _data:
		var i:int = _check_if_have(_data, null)
		if i == -1 :
			var weapon:Weapon = load(_data.weapon_path).instantiate() as Weapon
			add_child.call_deferred(weapon)
			weapon.ready_weapon.call_deferred()
			weapons.append(weapon)
			Signals.UpdateUiWithWeapon.emit(_data.duplicate())
		else:
			weapons[i].data.level += 1


func construct_trinket(_data) -> void:
	print("would construct trinket here")


func _check_if_have(_weapon:WeaponData = null, _trinket = null) -> int:
	if _weapon != null:
		var j:int = 0
		for each in weapons:
			if each.data.id == _weapon.id:
				return j
			j += 1
	
	if _trinket != null:
		pass

	return -1

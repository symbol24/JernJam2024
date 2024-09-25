class_name RadiationWeapon extends Weapon


var projectile:RadiationProjectile = null


func _ready() -> void:
	super()
	Signals.RoomEntered.connect(_receive_room_entered)


func _process(_delta: float) -> void:
	pass


func _receive_room_entered(_room_type:Room.Room_Type) -> void:
	if projectile == null:
		if _room_type == Room.Room_Type.COMBAT:
			_shoot_one_projectile()


func _shoot_one_projectile() -> void:
	var proj:Projectile = _get_projectile()
	if data.remain_on_player:
		parent.add_child(proj)
	else:
		Game.active_level.active_room.add_child(proj)
	proj.name = data.id + "_" + str(shoot_count) + "_" + str(spawned_projectile_count)
	proj.set_projectile(data.duplicate(), parent, _get_target())
	proj.shoot()
	projectile = proj



func _start(_incase = null) -> void:
	pass


func _stop(_incase = null) -> void:
	pass
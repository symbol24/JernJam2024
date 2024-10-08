class_name MapGenerator extends Node2D


@onready var level:Level = get_parent() as Level

var current_pos:Vector2 = Vector2.ZERO
var combat:CombatRoom
var shop:ShopRoom
var y_offset:float = -180


func _ready() -> void:
	Signals.RoomEntered.connect(_receive_room_entered)
	_instantiate_rooms(level.get_combat_room(), level.get_shop_room())
	if combat != null and shop != null:
		current_pos = _spawn_next_rooms(current_pos, y_offset)
		level.all_rooms_ready()


func _receive_room_entered(_room_type:Room.Room_Type) -> void:
	if _room_type == Room.Room_Type.SHOP:
		current_pos = _spawn_next_rooms(current_pos, y_offset)


func _spawn_next_rooms(_pos:Vector2 = Vector2.ZERO, _y_offset:float = -180) -> Vector2:
	if combat != null:
		var new_combat:CombatRoom = combat.duplicate()
		level.add_child.call_deferred(new_combat)
		new_combat.global_position = _pos
		_pos = Vector2(0, _pos.y + _y_offset)
		level.room_ready(new_combat)
		new_combat.name = "room_combat_" + str(level.rooms.size())

	if shop != null:
		var new_shop:ShopRoom = shop.duplicate()
		level.add_child.call_deferred(new_shop)
		new_shop.global_position = _pos
		_pos = Vector2(0, _pos.y + _y_offset)
		level.room_ready(new_shop)
		new_shop.name = "room_shop_" + str(level.rooms.size())
		new_shop.shop_loot_table = level.data.shop_loot_table

	return _pos


func _instantiate_rooms(_combat_room_data:RoomData, _shop_room_data:RoomData) -> void:
	#print("Trying to instantiate rooms.")
	if _combat_room_data == null or _shop_room_data == null:
		push_error("One or more room data missing in ", level.data.id, " level data.")
		return

	combat = load(_combat_room_data.path).instantiate() as CombatRoom

	shop = load(_shop_room_data.path).instantiate() as ShopRoom
	
	#print("Rooms instantiated.")
	


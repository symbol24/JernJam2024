class_name MapGenerator extends Node2D


@onready var level:Level = get_parent() as Level

var current_pos:Vector2 = Vector2.ZERO
var combat:CombatRoom
var shop:ShopRoom
var y_offset:float = -180


func _ready() -> void:
	Signals.RoomEntered.connect(_receive_room_entered)
	_instantiate_rooms(level.id)
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

	return _pos


func _instantiate_rooms(_level_id:String = "fantasy") -> void:
	var combat_path:String = DataManager.get_room_path(_level_id + "_combat")
	if combat_path: combat = load(combat_path).instantiate() as CombatRoom
	else: 
		push_error("No path found for ", _level_id, "_combat. Room instantiation interrupted.")
		return
	var shop_path:String = DataManager.get_room_path(_level_id + "_shop")
	if shop_path: shop = load(shop_path).instantiate() as ShopRoom
	else: 
		push_error("No path found for ", _level_id, "_shop. Room instantiation interrupted.")
		return
	


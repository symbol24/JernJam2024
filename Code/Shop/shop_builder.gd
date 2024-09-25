class_name ShopBuilder extends Node2D 


@export var shop_loot_table:LootTable
@export var item_points:Array[Marker2D]


func _ready() -> void:
	#_build_shop()
	Signals.RoomEntered.connect(_get_loot)


func _build_shop() -> void:
	var loot:Array = shop_loot_table.get_loot(item_points.size(), Game.player.data)
	var x:int = 0
	for item_data in loot:
		var shop_item:ShopItem = DataManager.shop_item.instantiate() as ShopItem
		add_child(shop_item)
		shop_item.set_data(item_data)
		shop_item.position = item_points[x].position
		x += 1
		

func _get_loot(_room_type:Room.Room_Type) -> void:
	if _room_type == Room.Room_Type.SHOP:
		_build_shop()
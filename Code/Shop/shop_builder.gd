class_name ShopBuilder extends Node2D

const SHOP_ITEM = preload("res://Scenes/Shop/shop_item.tscn")

@export var shop_loot_table:LootTable
@export var item_points:Array[Marker2D]


func _ready() -> void:
	_build_shop()


func _build_shop() -> void:
	var loot:Array = shop_loot_table.get_loot(item_points.size())
	var x:int = 0
	for item_data in loot:
		var shop_item:ShopItem = SHOP_ITEM.instantiate() as ShopItem
		add_child(shop_item)
		shop_item.set_data(item_data)
		shop_item.position = item_points[x].position
		x += 1
		

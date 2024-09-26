class_name ShopRoom extends Room


@onready var shop_builder:ShopBuilder = %ShopBuilder


var shop_loot_table:LootTable


func _ready() -> void:
	super()

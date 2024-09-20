class_name ShopItemReceiver extends SyAction


func _ready() -> void:
	Signals.ShopItemPurchased.connect(_receive_shop_item)


func _receive_shop_item(_item_data:ShopItemData) -> void:
	for type in _item_data.shop_item_type:
		match type:
			ShopItemData.Item_Type.LEVEL:
				parent.data.level += _item_data.item_amount
			ShopItemData.Item_Type.HEART:
				parent.data.bonus_hp += _item_data.item_amount
			ShopItemData.Item_Type.WEAPON:
				parent.construct_weapon(_item_data.weapon_data)
			ShopItemData.Item_Type.TRINKET:
				parent.construct_trinket(_item_data.trinket_data)
			_:
				pass

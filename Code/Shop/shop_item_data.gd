class_name ShopItemData extends Resource

enum Cost_Type {
				NONE = 0,
				CURRENCY = 1,
				HEALTH = 2,
				}

enum Item_Type {
				NONE = 0,
				LEVEL = 1,
				HEART = 2,
				WEAPON = 3,
				TRINKET = 4,
				}


@export var id:String
@export var cost_type:Cost_Type
@export var cost_amount:int = 0
@export var shop_item_type:Array[Item_Type]
@export var item_amount:int = 1
@export var weapon_data:WeaponData
@export var trinket_data:Resource
@export var icon_path:String

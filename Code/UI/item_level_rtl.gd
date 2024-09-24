class_name ShopItemRTL extends RichTextLabel

@export var item_data:ShopItemData

var id:String = ""
var level:int = 1
var max_level:int = 6


func _ready() -> void:
	Signals.ShopItemPurchased.connect(_update_text)


func setup(_id:String, _max_level:int) -> void:
	id = _id
	max_level = _max_level
	text = "[center]%s/%s[/center]"  % [level, max_level]


func _update_text(_shop_item_data:ShopItemData) -> void:
	print(_shop_item_data.id, " == ", "shop_" + id + "_data")
	if _shop_item_data.id == "shop_" + id + "_data":
		level += 1

		text = "[center]%s/%s[/center]"  % [level, max_level]
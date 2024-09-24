class_name ShopItem extends Area2D


@onready var buy_label: RichTextLabel = %buy_label
@onready var price_label: RichTextLabel = %price_label
@onready var currency: TileMapLayer = %currency
@onready var health: TileMapLayer = %health
@onready var icon_point: Marker2D = %icon_point

var data:ShopItemData
var depleted:bool = false


func _ready() -> void:
	buy_label.hide()
	currency.hide()
	health.hide()
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)


func interact(_data:CharacterData) -> Dictionary:
	var result:Dictionary = {"result":false}
	match data.cost_type:
		ShopItemData.Cost_Type.CURRENCY:
			if _data.coins >= data.cost_amount:
				result = {"result":true,"shopitemdata":data}
		ShopItemData.Cost_Type.HEALTH:
			if _data.current_hp > data.cost_amount:
				result = {"result":true,"shopitemdata":data}
		_:
			pass

	return result


func complete_purchase() -> void:
	queue_free.call_deferred()


func set_data(_data:ShopItemData) -> void:
	if _data:
		data = _data.duplicate()
		price_label.text = "[center]" + str(data.cost_amount) + "[/center]"
		match data.cost_type:
			ShopItemData.Cost_Type.CURRENCY:
				currency.show()
			ShopItemData.Cost_Type.HEALTH:
				health.show()
			_:
				pass
		var icon:Node2D = load(data.icon_path).instantiate() as Node2D
		add_child.call_deferred(icon)
		icon.position = icon_point.position
		name = data.id + "_0"


func _body_entered(_body) -> void:
	buy_label.show()


func _body_exited(_body) -> void:
	buy_label.hide()

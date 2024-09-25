class_name Interact extends SyAction


@onready var interact_detector: Area2D = %interact_detector

var item:ShopItem = null


func _input(_event: InputEvent) -> void:
	if item != null and Input.is_action_just_pressed("interact"):
		interact()


func _ready() -> void:
	interact_detector.area_entered.connect(_area_entered)
	interact_detector.area_exited.connect(_area_exited)


func interact() -> void:
	var result = item.interact(parent.data)
	if result.has("result") and result["result"]:
		var shopitemdata:ShopItemData = result["shopitemdata"]
		match shopitemdata.cost_type:
			ShopItemData.Cost_Type.CURRENCY:
				parent.data.coins -= shopitemdata.cost_amount
			ShopItemData.Cost_Type.HEALTH:
				parent.data.current_hp -= shopitemdata.cost_amount
			_:
				pass
		
		item.complete_purchase()
		Signals.ShopItemPurchased.emit(shopitemdata)


func _area_entered(_area) -> void:
	if _area is ShopItem:
		item = _area


func _area_exited(_area) -> void:
	if _area == item:
		item = null

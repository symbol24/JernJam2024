class_name Popups extends Control

@onready var small_popup:PanelContainer = %small_popup
@onready var small_popup_text:RichTextLabel = %small_popup_text


func _ready() -> void:
	small_popup.hide()
	Signals.EnterShopItem.connect(_display_shop_item)
	Signals.ExitShopItem.connect(_hide_shop_item)


func _display_small(_timer:float = 0.0) -> void:
	small_popup.show()
	if _timer > 0.0:
		await get_tree().create_timer(_timer).timeout
		small_popup.hide()


func _display_shop_item(_item:ShopItemData) -> void:
	if _item:
		small_popup_text.text = "[center]" + tr(_item.description)
		_display_small(0.0)


func _hide_shop_item(_item:ShopItemData) -> void:
	if small_popup.is_visible():
		small_popup_text.text = ""
		small_popup.hide()

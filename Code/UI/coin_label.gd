class_name CoinText extends RichTextLabel


func _ready() -> void:
	Signals.CoinsUpdated.connect(_update_text)


func _update_text(_value:int) -> void:
	text = str(_value)

class_name DamageNumberRTL extends RichTextLabel

var duration:float = 1.0
var distance:float = 10
var value

func set_damage_number(_value:String, _variation:String, _distance:float = 10, _duration:float = 2) -> void:
	text = _value
	value = _value
	theme_type_variation = _variation
	distance = _distance
	duration = _duration


func display_number() -> void:
	var tween:Tween = create_tween()
	show()
	tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y - distance), duration)
	await tween.finished
	_return_to_pool()


func _return_to_pool() -> void:
	hide()
	get_parent().remove_child.call_deferred(self)
	Signals.DmgNbrReturnToPool.emit(self)

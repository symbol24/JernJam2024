class_name PickupItem extends Area2D


var pickup_data:PickupData
var parent:Node
var player:SyCharacterBody2D
var tween:Tween
var start_position:Vector2


func _ready() -> void:
	Signals.RoomClear.connect(_go_to_player)


func set_pickup(_data:PickupData, _parent:Node, _player:SyCharacterBody2D) -> void:
	pickup_data = _data
	parent = _parent
	player = _player


func spawn_pickup(_position:Vector2) -> void:
	global_position = _position
	start_position = global_position
	show()


func pickup() -> PickupData:
	_return_to_pool()
	return pickup_data.duplicate() if pickup_data != null else PickupData.new()


func _return_to_pool() -> void:
	hide()
	if tween != null:
		tween.stop()
	parent.remove_child.call_deferred(self)
	Signals.PickupReturnToPool.emit(self)
	

func _go_to_player() -> void:
	tween = create_tween()
	tween.tween_property(self, "global_position", player.global_position, 1)

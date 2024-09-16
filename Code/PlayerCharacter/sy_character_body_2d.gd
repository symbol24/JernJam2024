class_name SyCharacterBody2D extends CharacterBody2D

@onready var character_range: Area2D = %character_range


var data:CharacterData
var enemies_in_range:Array[Enemy2D] = []


func _ready() -> void:
	character_range.body_entered.connect(_range_body_entered)
	character_range.body_exited.connect(_range_body_exited)
	Signals.CollectItem.connect(_collect_item)
	data = Game.selected_data.duplicate()
	data.setup_data(self)


func _physics_process(_delta: float) -> void:
	
	
	move_and_slide()


func set_velocity_by_move(_new_velocity:Vector2) -> void:
	velocity = _new_velocity


func _range_body_entered(_body) -> void:
	if _body is Enemy2D:
		enemies_in_range.append(_body as Enemy2D)


func _range_body_exited(_body) -> void:
	if _body is Enemy2D:
		enemies_in_range.erase(_body)


func _collect_item(_data:PickupData) -> void:
	match _data.type:
		PickupData.Type.SPECIAL:
			pass
		PickupData.Type.CURRENCY:
			data.coins += _data.value
		PickupData.Type.HEALTH:
			data.heal(_data.value)
		_:
			pass

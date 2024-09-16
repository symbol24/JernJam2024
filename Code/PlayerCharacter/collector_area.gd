class_name CollectorArea extends Area2D

@onready var collector_collider: CollisionShape2D = %collector_collider

var starting_range:float
var current_range:float
var total_percent:float = 0.0
var total_flat: float = 0.0


func _ready() -> void:
	starting_range = collector_collider.shape.radius
	current_range = starting_range
	area_entered.connect(_area_entered)
	Signals.UpdateCharacterRange.connect(_update_range)


func _area_entered(_area) -> void:
	if _area is PickupItem:
		Signals.CollectItem.emit(_area.pickup())


func _update_range(_percent:float = 0.0, _flat:float = 0.0) -> void:
	total_percent = _percent
	total_flat = _flat
	current_range = (starting_range + total_flat) * total_percent

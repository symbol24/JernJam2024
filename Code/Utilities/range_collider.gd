class_name RangeCollider extends CollisionShape2D


var starting_range:float
var current_range:float
var total_percent:float = 0
var total_flat:float = 0


func _ready() -> void:
	Signals.UpdateCharacterRange.connect(_update_range)
	starting_range = shape.radius
	current_range = starting_range


func _update_range(_percent:float, _flat_amount:float) -> void:
	total_flat += _flat_amount
	total_percent += _percent
	current_range = (starting_range + total_flat) * total_percent

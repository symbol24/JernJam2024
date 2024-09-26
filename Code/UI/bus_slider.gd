class_name BusSlider extends HSlider


@export var bus_id:String = "Master"

@onready var bus_name:RichTextLabel = %bus_name


func _ready() -> void:
	bus_name.text = bus_id
	# TODO: add set of value from audio manager


func _value_changed(_new_value: float) -> void:
	pass
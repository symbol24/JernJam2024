class_name BusSlider extends HSlider


@export var bus_id:String = "Master"

@onready var bus_name:RichTextLabel = %bus_name


func _ready() -> void:
	bus_name.text = bus_id
	value = Audio.DEFAULT.get(bus_id.to_lower()+"_volume")


func _value_changed(_new_value: float) -> void:
	Audio.BusVolumeUpdate.emit(bus_id, _new_value)
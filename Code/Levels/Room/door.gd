class_name Door extends StaticBody2D

@export var id:String = ""

@onready var closed_door: TileMapLayer = %closed_door
@onready var open_door: TileMapLayer = %open_door
@onready var collider: CollisionShape2D = %collider


func _ready() -> void:
	Signals.ToggleDoor.connect(_toggle_door)


func _toggle_door(_id:String = "", _open:bool = false) -> void:
	if _id == id:
		if _open:
			closed_door.hide()
			open_door.show()
			collider.set_deferred("disabled", true)
		else:
			closed_door.show()
			open_door.hide()
			collider.set_deferred("disabled", false)

class_name Door extends StaticBody2D


@export var id:String = ""
@export var is_top_door:bool = false

@onready var closed_door: TileMapLayer = %closed_door
@onready var open_door: TileMapLayer = %open_door
@onready var collider: CollisionShape2D = %collider
@onready var transition_detector: Area2D = %transition_detector


func _ready() -> void:
	Signals.ToggleDoor.connect(_toggle_door)
	Signals.RoomClear.connect(_open_door)
	transition_detector.body_entered.connect(_door_entered)


func _open_door() -> void:
	if is_top_door: _toggle_door(id, true)


func _toggle_door(_id:String = "", _open:bool = false) -> void:
	if _id == id:
		if _open:
			Audio.play_audio(DataManager.get_audio_file("door_open"))
			closed_door.hide()
			open_door.show()
			collider.set_deferred("disabled", true)
		else:
			closed_door.show()
			open_door.hide()
			collider.set_deferred("disabled", false)


func _door_entered(_body) -> void:
	if open_door.is_visible():
		Signals.TransitionToNextRoom.emit()

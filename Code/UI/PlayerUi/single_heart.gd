class_name SingleHeart extends Control

enum State {
			FULL = 0,
			EMPTY = 1,
			}

@onready var full_heart: TileMapLayer = %full_heart
@onready var empty: TileMapLayer = %empty

var id:int = -1

var current_state:State:
	set(value):
		current_state = value
		match current_state:
			State.FULL:
				full_heart.set_deferred("visible", true)
				empty.set_deferred("visible", false)
			State.EMPTY:
				full_heart.set_deferred("visible", false)
				empty.set_deferred("visible", true)

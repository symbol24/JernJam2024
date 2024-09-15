class_name SyCharacterBody2D extends CharacterBody2D

var data:CharacterData

func _ready() -> void:
	data = Game.selected_data.duplicate()


func _physics_process(_delta: float) -> void:
	
	
	move_and_slide()


func set_velocity_by_move(_new_velocity:Vector2) -> void:
	velocity = _new_velocity

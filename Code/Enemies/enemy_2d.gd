class_name Enemy2D extends CharacterBody2D

@export var enemy_data:EnemyData

var data:EnemyData


func _ready() -> void:
	data = enemy_data.duplicate()


func _physics_process(_delta: float) -> void:
	
	
	move_and_slide()


func set_velocity_by_move(_new_velocity:Vector2) -> void:
	velocity = _new_velocity

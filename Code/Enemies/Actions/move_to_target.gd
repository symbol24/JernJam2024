class_name MoveToTarget extends EnemyAction

@onready var target:SyCharacterBody2D = get_tree().get_first_node_in_group("player")







func _physics_process(_delta: float) -> void:
	parent.set_velocity_by_move(_move(global_position.direction_to(target.global_position), parent.velocity, parent.data.speed, _delta))


func _move(_input:Vector2 = Vector2.ZERO, _previous_vel:Vector2 = Vector2.ZERO, _speed:float = 0.0, _delta:float = 0.0) -> Vector2:
	var new_velocity:Vector2 = _previous_vel
	
	if _input != Vector2.ZERO:
		new_velocity = new_velocity.move_toward(_input * _speed, _speed)
	else:
		new_velocity = new_velocity.move_toward(Vector2.ZERO, _speed)
	
	return new_velocity

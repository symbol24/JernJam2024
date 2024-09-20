class_name Flail_Projectile extends Projectile


@onready var flail_sprite:Node2D = %flail_sprite

var target_is_left:bool:
	get:
		if parent != null and target != null: return _get_is_left(parent.global_position, target.global_position)
		else: return false
var total_rotation:float:
	get:
		return data.get_level_data_for("spin_radius")


func shoot():
	rotation_degrees = 225 if target_is_left else 45
	is_active = true
	_animate_flail()


func _animate_flail() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", rotation_degrees + total_rotation, data.projectile_life_time)
	await tween.finished
	_return_to_pool()


func _get_is_left(_position:Vector2, _target:Vector2) -> bool:
	var is_left:bool = true
	if _position.direction_to(_target).x > 0:
		is_left = false
	return is_left

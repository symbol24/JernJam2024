class_name CirclingProjectile extends Projectile



const DISTANCE_FROM_TARGET = 30

var angle : float = PI
var rotation_target_path
var projectile_speed:float:
	get:
		if data.level_data.has("projectile_speed"):
			print(data.level_data["projectile_speed"])
			return float(data.level_data["projectile_speed"])
		else:
			return 1
var life_timer:float = 0.0:
	set(value):
		life_timer = value
		if life_timer >= data.projectile_life_time:
			life_timer = 0.0
			_return_to_pool()


func _process(delta: float) -> void:
	if is_active:
		life_timer += delta
		angle += delta * projectile_speed

		var angle_vector = Vector2(cos(angle), sin(angle))
		global_transform.origin = parent.global_transform.origin

		position.x += angle_vector.x * DISTANCE_FROM_TARGET
		position.y += angle_vector.y * DISTANCE_FROM_TARGET
class_name CirclingProjectile extends Projectile



const DISTANCE_FROM_TARGET = 30

var tween_time:float = 0.3
var angle : float = PI
var rotation_target_path
var projectile_speed:float:
	get:
		if data.get_level_data_for("projectile_speed"):
			#print(data.level_data["projectile_speed"])
			return float(data.get_level_data_for("projectile_speed"))
		else:
			return 1
var life_timer:float = 0.0:
	set(value):
		life_timer = value
		if life_timer >= data.projectile_life_time - tween_time:
			life_timer = 0.0
			_return_to_pool()


func _process(delta: float) -> void:
	if is_active:
		life_timer += delta
		rotate((0.002 * projectile_speed) + delta)


func _return_to_pool() -> void:
	var tween:Tween = self.create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, tween_time)
	await tween.finished
	set_deferred("is_active", false)
	Signals.ReturnProjectileToPool.emit(self)
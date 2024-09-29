class_name InterdictionWeapon extends Weapon


func _shoot_one_projectile() -> void:
	if is_active:
		var rot_deg:float = 360/data.projectile_count
		var tween:Tween = self.create_tween()
		for i in data.projectile_count:
			var proj:Projectile = _get_projectile()
			if data.remain_on_player:
				parent.add_child(proj)
			else:
				Game.active_level.active_room.add_child(proj)
			proj.name = data.id + "_" + str(shoot_count) + "_" + str(spawned_projectile_count)
			var target = _get_target()
			proj.set_projectile(data.duplicate(), parent, target)
			proj.modulate = Color.TRANSPARENT
			proj.rotation_degrees = rot_deg * i
			tween.parallel()
			tween.tween_property(proj, "modulate", Color.WHITE, 0.3)
			proj.shoot()
			shoot_count += 1
			spawned_projectile_count += 1
			shoot_timer_active = false
		shoot_count = 0
		timer_active = true


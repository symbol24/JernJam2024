class_name Shaker extends ColorRect

# Screen shaker
var current_shake_strength:float = 0
var shake_time:float = 0:
	set(_value):
		shake_time = _value
		if shake_time <= 0:
			shake = false
var shake:bool = false:
	set(_value):
		shake = _value
		if shake: material.set_shader_parameter("ShakeStrength", max(current_shake_strength,0))
		else: material.set_shader_parameter("ShakeStrength", 0)


func _ready() -> void:
	Signals.Shake.connect(_shake)


func _process(delta: float) -> void:
	if shake:
		shake_time -= delta
		

func _shake(_time:float, _strength:float) -> void:
	shake_time = _time
	current_shake_strength = _strength
	shake = true
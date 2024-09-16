class_name Boot extends Node2D

@onready var animator: AnimationPlayer = %animator

var current:String = ""
var can_press:bool = true


func _input(_event: InputEvent) -> void:
	if can_press and Input.is_anything_pressed():
		_skip()

func _ready() -> void:
	Signals.ToggleControl.emit("main_menu", false)
	animator.animation_finished.connect(_play)
	await get_tree().create_timer(0.5).timeout
	animator.play("godot")
	current = "godot"
	

func _play(_anim:String):
	if _anim == "godot":
		current = "rid"
		animator.play("rid")
	elif _anim == "rid":
		current = "warning1"
		animator.play("warning1")
	elif _anim == "warning1":
		Signals.ToggleControl.emit("main_menu")
		queue_free.call_deferred()


func _skip() -> void:
	can_press = false
	animator.play("RESET")
	await animator.animation_finished
	if current == "godot":
		current = "rid"
		animator.play("rid")
	elif current == "rid":
		current = "warning1"
		animator.play("warning1")
	elif current == "warning1":
		Signals.ToggleControl.emit("main_menu", true)
		queue_free.call_deferred()
	
	await get_tree().create_timer(0.2).timeout
	can_press = true

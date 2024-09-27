class_name MainMenu extends SyControl


@onready var animator:AnimationPlayer = %animator

var skip:bool = false
var played:bool = false


func _ready() -> void:
	Signals.SkipMainMenuMusic.connect(_check_skip)


func play_entry() -> void:
	animator.play("intro")


func _play_sparkle() -> void:
	if not skip:
		Audio.play_audio(DataManager.get_audio_file("logo_sparkle"))
		await get_tree().create_timer(0.3).timeout
	if not skip:
		Audio.play_audio(DataManager.get_audio_file("main_menu_music"))
		played = true
	
	skip = false


func _check_skip() -> void:
	if played:
		played = false
	else:
		skip = true
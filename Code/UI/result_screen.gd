class_name ResultScreen extends SyControl


@onready var death_count:RichTextLabel = %death_count
@onready var quit_btn:Button = %quit_btn


func _ready() -> void:
	Signals.RunEnded.connect(_update_death_count)


func _update_death_count() -> void:
	death_count.text = str(Game.player.data.defeats)


func play_entry() -> void:
	Audio.play_audio(DataManager.get_audio_file("result_music"))
	quit_btn.grab_focus()
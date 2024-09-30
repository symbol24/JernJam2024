class_name ResultScreen extends SyControl


@onready var death_count:RichTextLabel = %death_count
@onready var quit_btn:Button = %quit_btn


func play_entry() -> void:
	Audio.play_audio(DataManager.get_audio_file("result_music"))
	quit_btn.grab_focus()
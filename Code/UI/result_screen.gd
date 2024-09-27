class_name ResultScreen extends SyControl


@onready var death_count:RichTextLabel = %death_count


func _ready() -> void:
	Signals.RunEnded.connect(_update_death_count)


func _update_death_count() -> void:
	death_count.text = str(Game.death_count)
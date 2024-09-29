class_name DeathControl extends Control


const CHAR_DELAY:float = 0.05

enum State {
				WAITING_FIRST_DEATH = 0,
				FIRST_RESET = 1,
				SECOND_RESET = 2,
				FANTASY_DIFFICULT = 3,
				MODERN_NORMAL = 4,
				MODERN_DIFFICULT = 5,
				FANTASY_DIFFICULT_ONLY_RAD = 6,
				MODERN_NO_WEAPONS = 7,
				DEATH_GIVES_UP = 8,
				TEST = 9,
			}


@export var skip_delay:float = 0.1
@export var death_count_for_first_reset:int = 20
@export var death_count_for_second_reset:int = 5
@export var death_count_for_fantasy_difficult:int = 5
@export var death_count_for_modern_normal:int = 5
@export var death_count_for_modern_difficult:int = 5
@export var death_count_for_fantasy_difficult_only_rad:int = 5
@export var death_count_for_modern_no_weapon:int = 5
@export var death_count_for_death_give_up:int = 50
@export var room_count_check:int = 40
@export var level_count_check:int = 20
@export var final_timer_delay:float = 180

@onready var sprite: TileMapLayer = %sprite
@onready var dialogue_text:RichTextLabel = %dialogue_text

var current_state:State = State.TEST
var normal_delay:float:
	get:
		return char_count * CHAR_DELAY
var current_dialogue_id:String = ""
var char_count := 0
var show_delay := 0.2
var char_update := false
var current_text:String
var starting_pos:Vector2
var skip:bool = false
var displaying:bool = false
var d_tween:Tween
var r_tween:Tween
var death_move_delay:float = randf_range(0.05,0.15)
var last_death_count:int = 0
var room_count:int = 0
var audio_timer:float = 0.0:
	set(value):
		audio_timer = value
		if audio_timer >= CHAR_DELAY:
			audio_timer = 0.0
			_play_blurp()
var final_timer:float = 0.0:
	set(value):
		final_timer = value
		if final_timer >= final_timer_delay:
			final_timer = 0.0
			_final_trigger()


func _ready() -> void:
	starting_pos = sprite.position
	Signals.DisplayText.connect(_display_text)
	Signals.SkipDialogue.connect(_skip)
	Signals.RoomEntered.connect(_check_dialogue_trigger)
	Signals.CharacterDefeated.connect(_death_check)


func _process(delta: float) -> void:
	if displaying: audio_timer += delta
	if Game.active_level != null and current_state == State.MODERN_NO_WEAPONS: 
		final_timer += delta


func _play_blurp() -> void:
	Audio.play_audio(DataManager.get_audio_file("text_blurp"))


func _display_text(_id:String) -> void:
	current_dialogue_id = _id
	var line_id:String = DataManager.get_dialogue(_id)
	if line_id != "done":
		current_text = tr(line_id)
		dialogue_text.text = current_text
		char_count = dialogue_text.get_total_character_count()
		dialogue_text.set_visible_ratio(0)
		_display_with_ratio(normal_delay)
	else:
		dialogue_text.text = ""
		Signals.ToggleControl.emit(UI.last_menu, true, "dialogue")
		_trigger_next_sequence(current_state)


func _move() -> void:
	if d_tween != null: 
		d_tween.kill()
		d_tween = null
	d_tween = sprite.create_tween()
	d_tween.set_loops(3)
	var height:Vector2 = Vector2.UP * 3
	var delay:float = death_move_delay
	d_tween.tween_property(sprite, "position", starting_pos + height, delay)
	d_tween.tween_property(sprite, "position", starting_pos, delay)


func _display_with_ratio(_delay:float) -> void:
	displaying = true
	if r_tween != null: r_tween.kill()
	r_tween = dialogue_text.create_tween()
	r_tween.finished.connect(_end_displaying)
	r_tween.tween_property(dialogue_text, "visible_ratio", 1.0, _delay)
	_move()


func _end_displaying() -> void:
	displaying = false


func _skip() -> void:
	if displaying: 
		if not skip: 
			skip = true
			displaying = false
			audio_timer = 0.0
			_display_with_ratio(skip_delay)
		else: 
			_clear_current()
			_display_text(current_dialogue_id)
	else: 
		_clear_current()
		_display_text(current_dialogue_id)
		

func _clear_current() -> void:
	dialogue_text.text = ""
	skip = false
	displaying = false
	audio_timer = 0.0


func _check_dialogue_trigger(_room_type:Room.Room_Type) -> void:
	room_count += 1
	if _room_type == Room.Room_Type.SHOP:
		match current_state:
			State.WAITING_FIRST_DEATH:
				if Game.player.data.defeats >= death_count_for_first_reset or room_count >= room_count_check or Game.player.data.level >= level_count_check:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("first_appearance")
					current_state = State.FIRST_RESET
			State.FIRST_RESET:
				if Game.player.data.defeats >= last_death_count + death_count_for_second_reset or room_count >= room_count_check or Game.player.data.level >= level_count_check:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("second_reset")
					current_state = State.SECOND_RESET
			State.SECOND_RESET:
				if Game.player.data.defeats >= last_death_count + death_count_for_fantasy_difficult or room_count >= room_count_check or Game.player.data.level >= level_count_check:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("to_fantasy_difficult")
					current_state = State.FANTASY_DIFFICULT
			State.FANTASY_DIFFICULT:
				if Game.player.data.defeats >= last_death_count + death_count_for_modern_normal or room_count >= room_count_check or Game.player.data.level >= level_count_check:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("to_modern_normal")
					current_state = State.MODERN_NORMAL
			State.MODERN_NORMAL:
				if Game.player.data.defeats >= last_death_count + death_count_for_modern_difficult or room_count >= room_count_check or Game.player.data.level >= level_count_check:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("to_modern_difficult")
					current_state = State.MODERN_DIFFICULT
			State.MODERN_DIFFICULT:
				if Game.player.data.defeats >= last_death_count + death_count_for_fantasy_difficult_only_rad or room_count >= room_count_check or Game.player.data.level >= level_count_check:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("to_fantasy_only_rad")
					current_state = State.FANTASY_DIFFICULT_ONLY_RAD
			State.FANTASY_DIFFICULT_ONLY_RAD:
				if Game.player.data.defeats >= last_death_count + death_count_for_modern_no_weapon or room_count >= room_count_check or Game.player.data.level >= level_count_check:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("to_modern_no_weapons")
					current_state = State.MODERN_NO_WEAPONS
			_:
				pass
		
	last_death_count = Game.player.data.defeats
	

func _trigger_next_sequence(_current_state:State) -> void:
	room_count = 0
	match _current_state:
		State.WAITING_FIRST_DEATH:
			pass
		State.FIRST_RESET:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("fantasy_normal")
		State.SECOND_RESET:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("fantasy_normal")
		State.FANTASY_DIFFICULT:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("fantasy_difficult")
		State.MODERN_NORMAL:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("modern_normal")
		State.MODERN_DIFFICULT:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("modern_difficult")
		State.FANTASY_DIFFICULT_ONLY_RAD:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("fantasy_rad_only")
		State.MODERN_NO_WEAPONS:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("modern_no_weapons")
		State.DEATH_GIVES_UP:
			Signals.RunEnded.emit()
			Signals.ToggleControl.emit("result_screen", true, "dialogue")
			current_state = State.WAITING_FIRST_DEATH
			last_death_count = 0
		_:
			pass


func _death_check(_char_data:BaseCharacterData) -> void:
	if current_state == State.MODERN_NO_WEAPONS and _char_data is CharacterData:
		if Game.player.data.defeats >= last_death_count + death_count_for_death_give_up:
			_final_trigger()
			


func _final_trigger() -> void:
	Game.pause_tree(true)
	Signals.ToggleControl.emit("dialogue", true, "player_ui")
	_display_text("death_gives_up")
	current_state = State.DEATH_GIVES_UP
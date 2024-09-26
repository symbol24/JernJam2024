class_name DeathControl extends Control


enum State {
				NORMAL = 0,
				FIRST_APPEARANCE = 1,
				FIRST_RESET = 2,
				FIRST_DIFF_CHANGE = 3,
			}


@export var normal_delay:float = 5
@export var skip_delay:float = 0.1
@export var first_appearance_death_count:int = 20
@export var first_reset_death_count:int = 5
@export var first_diff_change_death_count:int = 5

@onready var sprite: TileMapLayer = %sprite
@onready var dialogue_text:RichTextLabel = %dialogue_text

var current_state:State = State.NORMAL

var current_dialogue_id:String = ""
var char_count := 0
var current := 0
var timer := 0.0
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


func _ready() -> void:
	starting_pos = sprite.position
	Signals.DisplayText.connect(_display_text)
	Signals.SkipDialogue.connect(_skip)
	Signals.RoomEntered.connect(_check_dialogue_trigger)


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
	r_tween.tween_property(dialogue_text, "visible_ratio", 1.0, _delay)
	_move()


func _skip() -> void:
	if displaying: 
		if not skip: 
			skip = true
			displaying = false
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


func _check_dialogue_trigger(_room_type:Room.Room_Type) -> void:
	#print("not first_appearance ", not first_appearance, " Game.player.data.defeats ", Game.player.data.defeats)

	if _room_type == Room.Room_Type.SHOP:
		match current_state:
			State.NORMAL:
				#print("first_appearance_death_count ", first_appearance_death_count)
				if Game.player.data.defeats > first_appearance_death_count:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("first_appearance")
					current_state = State.FIRST_APPEARANCE
			State.FIRST_APPEARANCE:
				if Game.player.data.defeats > last_death_count + first_reset_death_count:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("first_reset")
					current_state = State.FIRST_RESET
			State.FIRST_RESET:
				if Game.player.data.defeats > last_death_count + first_diff_change_death_count:
					Signals.ToggleControl.emit("dialogue", true, "player_ui")
					_display_text("first_diff_change")
					current_state = State.FIRST_DIFF_CHANGE
			State.FIRST_DIFF_CHANGE:

				pass
			_:
				pass
		
	last_death_count = Game.player.data.defeats

	
func _trigger_next_sequence(_cuurent_state:State) -> void:
	match _cuurent_state:
		State.NORMAL:
			pass
		State.FIRST_APPEARANCE:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("fantasy")
		State.FIRST_RESET:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("fantasy")
		State.FIRST_DIFF_CHANGE:
			Signals.RestCharacter.emit()
			Signals.LoadLevel.emit("modern_normal")
			
		_:
			pass
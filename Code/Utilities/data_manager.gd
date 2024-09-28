extends Node2D


const MUSIC = [
				"res://Data/Audio/main_menu_music.tres",
				"res://Data/Audio/fantasy_music.tres",
				"res://Data/Audio/modern_music.tres",
				"res://Data/Audio/shop_music.tres",
				"res://Data/Audio/result_music.tres",
			]
const SFX = [
			"res://Data/Audio/coin_pickup.tres", 
			"res://Data/Audio/heal_pickup.tres",
			"res://Data/Audio/main_menu_btn_press.tres",
			"res://Data/Audio/main_menu_sparkle.tres",
			"res://Data/Audio/player_hit.tres",
			"res://Data/Audio/shop_buy.tres",
			"res://Data/Audio/bubble_shoot.tres",
			"res://Data/Audio/flail_swing.tres",
			"res://Data/Audio/interdiction_appear.tres",
			"res://Data/Audio/knife_throw.tres",
			"res://Data/Audio/tornado_spawn.tres",
			"res://Data/Audio/door_open.tres",
			"res://Data/Audio/text_blurp.tres",
			"res://Data/Audio/bubble_pop.tres",
			"res://Data/Audio/buy_cant.tres",
			"res://Data/Audio/bubble_pop.tres",
			]


@export var character_datas:Array[CharacterData] = []
@export var levels:LevelLoadData
@export var shop_item:PackedScene
@export var damage_number:PackedScene
@export var hp_heart:PackedScene
@export var item_label:PackedScene
@export var dialogue_lists:Array[DialogueData]
@export var room_list:Array[RoomData]
@export var generic_level:PackedScene

var sfx:Array[AudioFile] = []
var music:Array[AudioFile] = []


func _ready() -> void:
	sfx = _load_audio_files(SFX)
	music = _load_audio_files(MUSIC)


func get_dialogue(_id:String) -> String:
	for each in dialogue_lists:
		if each.id == _id:
			return each.get_next()
	return "[list not found]"


func get_room_path(_room_name:String) -> String:
	#print("receiving room name: ", _room_name)
	for each in room_list:
		if _room_name == each.id:
			#print(" returning room path: ", each.path)
			return each.path
	return ""


func _load_audio_files(_paths:Array) -> Array[AudioFile]:
	var result:Array[AudioFile] = []
	for path in _paths:
		var audio_file:AudioFile = load(path)
		if audio_file:
			result.append(audio_file)
	return result


func get_audio_file(_id:String) -> AudioFile:
	for file in music:
		if file.id == _id: return file
	for file in sfx:
		if file.id == _id: return file
	return null
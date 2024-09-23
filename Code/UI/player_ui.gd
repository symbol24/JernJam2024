class_name PlayerUi extends SyControl


@onready var player_hp: PanelContainer = %player_hp
@onready var player_hearts: GridContainer = %player_hearts
@onready var player_level: RichTextLabel = %player_level
@onready var player_name: RichTextLabel = %player_name
@onready var player_weapons: GridContainer = %player_weapons
@onready var player_trinkets: GridContainer = %player_trinkets

var hearts:Array[SingleHeart] = []
var weapons:Array[WeaponData] = []
var trinkets:Array = []
var displayed_weapons:Array[Control] = []
var displayed_trinkets:Array[Control] = []

func _ready() -> void:
	super()
	Signals.ConstructHP.connect(_construct_hp)
	Signals.HpUpdated.connect(_update_hp)
	Signals.PlayerReady.connect(_update_character_name)
	Signals.CharacterLevelUpdated.connect(_update_level)
	Signals.UpdateUiWithWeapon.connect(_update_weapons)
	Signals.UpdateUiWithTrinket.connect(_update_trinkets)


func _construct_hp(_character:BaseCharacterData) -> void:
	if not hearts.is_empty():
		for each in hearts:
			player_hearts.remove_child(each)
			each.queue_free()
		hearts.clear()
	var j:int = 0
	for i in _character.max_hp:
		var new_heart:SingleHeart = DataManager.hp_heart.instantiate() as SingleHeart
		player_hearts.add_child(new_heart)
		new_heart.current_state = SingleHeart.State.FULL if j < _character.current_hp else SingleHeart.State.EMPTY
		hearts.append(new_heart)
		new_heart.name = "heart_"+str(j)
		new_heart.id = j
		j += 1


func _update_hp(_character:BaseCharacterData) -> void:
	if _character.id == Game.selected_data.id:
		var i:int = 0
		for heart in hearts:
			if i < _character.current_hp: heart.current_state = SingleHeart.State.FULL
			else: heart.current_state = SingleHeart.State.EMPTY
			i += 1


func _update_level(_data:BaseCharacterData) -> void:
	if _data.id == Game.active_level.player.data.id:
		player_level.text = "[center]" + str(_data.level) + "[/center]"


func _update_character_name(_character:CharacterBody2D) -> void:
	player_name.text = _character.data.id


func _update_weapons(_weapon:WeaponData) -> void:
	if _weapon:
		weapons.append(_weapon)
		
		var new:Node2D = load(_weapon.icon_path).instantiate() as Node2D
		var control:Control = Control.new()
		control.add_child(new)
		control.set_custom_minimum_size(Vector2(12,12))
		player_weapons.add_child.call_deferred(control)
		
		displayed_weapons.append(control)


func _update_trinkets(_trinket:TrinketData) -> void:
	if _trinket:
		trinkets.append(_trinket)

		var new:Node2D = load(_trinket.icon_path).instantiate() as Node2D
		var control:Control = Control.new()
		control.add_child(new)
		control.set_custom_minimum_size(Vector2(12,12))
		player_trinkets.add_child.call_deferred(control)
		
		displayed_trinkets.append(control)
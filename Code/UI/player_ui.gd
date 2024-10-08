class_name PlayerUi extends SyControl


@onready var player_hp: PanelContainer = %player_hp
@onready var player_hearts: GridContainer = %player_hearts
@onready var player_level: RichTextLabel = %player_level
@onready var player_name: RichTextLabel = %player_name
@onready var player_weapons: GridContainer = %player_weapons
@onready var player_trinkets: GridContainer = %player_trinkets
@onready var level_name:RichTextLabel = %level_name
@onready var level_difficulty:RichTextLabel = %level_difficulty
@onready var enemy_level:RichTextLabel = %enemy_level
@onready var room_count:RichTextLabel = %room_count

var hearts:Array[SingleHeart] = []
var weapons:Array[WeaponData] = []
var trinkets:Array[TrinketData] = []
var displayed_weapons:Array[Control] = []
var displayed_trinkets:Array[Control] = []
var count:int = 0

func _ready() -> void:
	super()
	Signals.ConstructHP.connect(_construct_hp)
	Signals.HpUpdated.connect(_update_hp)
	Signals.PlayerReady.connect(_update_character_name)
	Signals.CharacterLevelUpdated.connect(_update_level)
	Signals.UpdateUiWithWeapon.connect(_update_weapons)
	Signals.UpdateUiWithTrinket.connect(_update_trinkets)
	Signals.ResetPlayerUi.connect(_reset)
	Signals.UpdateLevelData.connect(_update_level_data)
	Signals.RoomEntered.connect(_update_enemy_level)


func _update_level_data(_level:Level) -> void:
	level_name.text = tr(_level.data.level_name)
	level_difficulty.text = tr(_level.data.level_difficulty)


func _update_enemy_level(_room_type:Room.Room_Type) -> void:
	if _room_type == Room.Room_Type.COMBAT:
		enemy_level.text = "[right]" + str(Game.active_level.enemy_spawner._get_enemy_level())
		room_count.text = "[right]" + str(Game.active_level.enemy_spawner.room_count-1)


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
	player_name.text = tr(_character.data.id)


func _update_weapons(_weapon:WeaponData) -> void:
	if _weapon:
		weapons.append(_weapon)
		var control:Control = _create_item_ui(_weapon.icon_path) as Control
		var level_rtl:ShopItemRTL = DataManager.item_label.instantiate() as ShopItemRTL
		control.add_child(level_rtl)
		level_rtl.position = Vector2(0,9)
		level_rtl.setup(_weapon.id, WeaponData.MAX_LEVEL)
		displayed_weapons.append(control)
		player_weapons.add_child.call_deferred(control)


func _update_trinkets(_trinket:TrinketData) -> void:
	if _trinket:
		trinkets.append(_trinket)
		var control:Control = _create_item_ui(_trinket.icon_path) as Control
		var level_rtl:ShopItemRTL = DataManager.item_label.instantiate() as ShopItemRTL
		control.add_child(level_rtl)
		level_rtl.position = Vector2(0,9)
		level_rtl.setup(_trinket.id, TrinketData.MAX_LEVEL)
		displayed_trinkets.append(control)
		player_trinkets.add_child.call_deferred(control)


func _create_item_ui(_path:String) -> Control:
	var new:Node2D = load(_path).instantiate() as Node2D
	var control:Control = Control.new()
	control.add_child(new)
	control.set_custom_minimum_size(Vector2(12,12))
	control.name = "item_0" + str(count)
	count += 1
	return control


func _reset() -> void:
	for each in displayed_weapons:
		if each.get_parent():
			each.remove_child.call_deferred(each)
		each.queue_free.call_deferred()
	displayed_weapons.clear()
	for each in displayed_trinkets:
		if each.get_parent():
			each.remove_child.call_deferred(each)
		each.queue_free.call_deferred()
	displayed_trinkets.clear()
	weapons.clear()
	trinkets.clear()
	count = 0
	player_level.text = "[center]1[/center]"

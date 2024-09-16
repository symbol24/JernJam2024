class_name PlauerUi extends SyControl

const SINGLE_HEART = preload("res://Scenes/UI/PlayerUi/single_heart.tscn")

@onready var player_hp: PanelContainer = %player_hp
@onready var player_hearts: GridContainer = %player_hearts

var hearts:Array[SingleHeart] = []


func _ready() -> void:
	Signals.ConstructHP.connect(_construct_hp)
	Signals.HpUpdated.connect(_update_hp)


func _construct_hp(_amount:int) -> void:
	for i in _amount:
		var new_heart:SingleHeart = SINGLE_HEART.instantiate() as SingleHeart
		player_hearts.add_child(new_heart)
		new_heart.current_state = SingleHeart.State.FULL
		hearts.append(new_heart)
		new_heart.name = "heart_"+str(i)
		new_heart.id = i


func _update_hp(_character:BaseCharacterData) -> void:
	if _character.id == Game.selected_data.id:
		var i:int = 0
		for heart in hearts:
			if i < _character.current_hp: heart.current_state = SingleHeart.State.FULL
			else: heart.current_state = SingleHeart.State.EMPTY
			i += 1

extends Node

const CHARACTER_DATA = preload("res://Data/main_character.tres")
const LEVELS = preload("res://Data/levels.tres")
const CAMERA_TRANSITION_TIME:float = 0.5

# Damage constants
const MAX_CC:float = 0.8
const OVERFLOW_PERCENTAGE:float = 1.0

# Will change if add character selector
var selected_data:CharacterData = CHARACTER_DATA
var player:SyCharacterBody2D

# A quick variable to check if the tree is paused.
var is_paused:bool:
	get:
		return get_tree().paused
		
#Levels and loading
var active_level:Node
var is_loading := false
var to_load := ""
var load_complete := false
var loading_status := 0.0
var progress := []
var extra_loading := false


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.LoadLevel.connect(_load_level)
	Signals.LevelReady.connect(_level_ready)


func _physics_process(_delta: float) -> void:
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(to_load, progress)
		
		# When loading is complete in ResourceLoader, launch the _complete_load function.
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()


func get_closest_between(_object:Node2D, _list:Array) -> Node2D:
	if _object and not _list.is_empty():
		var closest = _list[0]
		var last_check = _object.global_position.distance_squared_to(closest.global_position)
		for each in _list:
			var check = _object.global_position.distance_squared_to(each.global_position)
			if check < last_check: 
				closest = each
				last_check = check
		return closest
	push_error("_get_closest_between was sent faulty parameters")
	return null


func _load_level(_id:String = "") -> void:
	pause_tree(true)
	# Send loadscreen toggle on
	Signals.ToggleControl.emit("loading", true)
	
	# If path is empty, dont try to load.
	if not LEVELS.levels.has(_id): return
	var path:String = LEVELS.levels[_id]
	if path == "": return
	
	# If there is an active level, queue_free it.
	if active_level != null: 
		var temp := active_level
		remove_child.call_deferred(temp)
		temp.queue_free.call_deferred()
	
	# Starting the ResourceLoader.
	to_load = path
	is_loading = true
	load_complete = false
	ResourceLoader.load_threaded_request(to_load)


func _complete_load() -> void:
	is_loading = false
	
	# Get the new level from the ResourceLoader and instantiate it.
	var new_level := ResourceLoader.load_threaded_get(to_load)
	active_level = new_level.instantiate()
	add_child.call_deferred(active_level)
	


func _level_ready(_level:Level) -> void:
	if _level == active_level:
		pause_tree(false)
		
		# Adding load time if set in the level data
		if LEVELS.loading_delay > 0.0:
			var wait_timer := get_tree().create_timer(LEVELS.loading_delay)
			await wait_timer.timeout
			
		# Send loadscreen toggle off
		Signals.ToggleControl.emit("loading", false)


func pause_tree(_value:bool = false) -> void:
	get_tree().paused = _value


func get_character() -> SyCharacterBody2D:
	if player != null: return player
	else:
		player = load(selected_data.path).instantiate() as SyCharacterBody2D
		player.data = selected_data.duplicate()
		return player
		
	

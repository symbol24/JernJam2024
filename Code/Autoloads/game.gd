extends Node


const CAMERA_TRANSITION_TIME:float = 0.5

# Damage constants
const MAX_CC:float = 0.8
const OVERFLOW_PERCENTAGE:float = 1.0


# Will change if add character selector
var selected_data:CharacterData
var player:SyCharacterBody2D

# A quick variable to check if the tree is paused.
var is_paused:bool:
	get:
		return get_tree().paused
		
#Levels and loading
var levels = DataManager.levels
var active_level:Level
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


func parse_json_data(_json:String) -> Dictionary:
	var result:Dictionary
	var file = FileAccess.open(_json, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(json_string)
		if error != OK:
			push_error("JSON file parsing failed for ", _json)
			return result
		
		result = json.data.duplicate()
		file.close()
	return result


func _load_level(_id:String = "") -> void:
	#print("Trying to load level: ", _id)
	pause_tree(true)
	# Send loadscreen toggle on
	Signals.ToggleControl.emit("loading", true)
	if not levels.has_level(_id): 
		push_error("Level %s id not found in level list." % _id)
		return
	
	# If there is an active level, queue_free it.
	if active_level != null: 
		var temp := active_level
		remove_child.call_deferred(temp)
		temp.queue_free.call_deferred()
		await get_tree().process_frame

	var level_data:LevelData = levels.get_level_data(_id)
	active_level = DataManager.generic_level.instantiate() as Level
	active_level.data = level_data
	if levels.loading_delay > 0.0:
		await get_tree().create_timer(levels.loading_delay).timeout
	#print("Adding level as child")
	#print(active_level.data.id)
	add_child(active_level)
	


func _load_level_old(_id:String = "") -> void:
	pause_tree(true)
	# Send loadscreen toggle on
	Signals.ToggleControl.emit("loading", true)
	#print("receving level id: ", _id)
	# If path is empty, dont try to load.
	if not levels.has_level(_id): return
	var path:String = levels.levels[_id]
	#print("Found path: ", path)
	if path == "": return
	
	# If there is an active level, queue_free it.
	if active_level != null: 
		var temp := active_level
		remove_child.call_deferred(temp)
		temp.queue_free.call_deferred()
		await get_tree().process_frame
	
	# Starting the ResourceLoader.
	to_load = path
	is_loading = true
	load_complete = false
	ResourceLoader.load_threaded_request(to_load)


func _complete_load() -> void:
	is_loading = false
	#print("load complete for ", to_load)

	# Get the new level from the ResourceLoader and instantiate it.
	var new_level := ResourceLoader.load_threaded_get(to_load)
	active_level = new_level.instantiate()
	add_child.call_deferred(active_level)
	

func _level_ready(_level:Level) -> void:
	if _level == active_level:
		pause_tree(false)
		
		# Adding load time if set in the level data
		#if levels.loading_delay > 0.0:
		#	var wait_timer := get_tree().create_timer(levels.loading_delay)
		#	await wait_timer.timeout
			
		# Send loadscreen toggle off
		Signals.ToggleControl.emit("loading", false)


func pause_tree(_value:bool = false) -> void:
	get_tree().paused = _value
	#print(get_tree().paused)


func get_character() -> SyCharacterBody2D:
	if player != null: return player
	else:
		if active_level.data.character is CharacterData:
			selected_data = active_level.data.character
			player = load(active_level.data.character.path).instantiate() as SyCharacterBody2D
			player.data = active_level.data.character.duplicate(true)
		else: push_error("For some reasonm selected_data is not a character_data...")

		return player

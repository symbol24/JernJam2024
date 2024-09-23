class_name DialogueData extends Resource

@export var id:String = ""
@export var lines:Array[String] = []

var current:int = -1


func get_next() -> String:
	if current < lines.size() - 1:
		current += 1
		#print("returning current ", current)
		return lines[current]
	
	return "done"
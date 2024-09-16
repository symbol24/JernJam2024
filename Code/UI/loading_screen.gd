class_name LoadingScreen extends SyControl

@onready var logo: PanelContainer = %logo

var spin_speed:float = 3


func _process(_delta: float) -> void:
	if visible:
		logo.rotation += _delta * spin_speed

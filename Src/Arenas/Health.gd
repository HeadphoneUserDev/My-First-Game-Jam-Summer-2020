extends Label

onready var player = get_node("../../Player_01")

func _ready():
	
	
	
	pass

func health(value):
	
	var health_value = value
	text = str(int(health_value))
	
	pass

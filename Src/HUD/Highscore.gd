extends Label

func _ready():
	
	text = str(int(Global.highscore))
	
	
	pass

func _process(delta):
	
	if Global.points > Global.highscore:
		Global.highscore = Global.points
	#I still don't understand why this doesn't update until the game reloads but ehhh it works I guess
	
	pass

extends Label

func _ready():
	pass

func score_event():
	
	var score_value = 1 + randi()%5
	Global.points += score_value
	text = str(int(Global.points))
#	Global.points = text
	
	var score_notification = load("res://Src/ScoreNotifications/BaseN.tscn").instance()
	get_node("..").add_child(score_notification)
	score_notification.position = Vector2((rect_size.x/2) - 320 + randf()*640, rect_size.y/2)
	while score_notification.position.x > 540 and score_notification.position.x < 740:
		score_notification.position = Vector2((rect_size.x/2) - 320 + randf()*640, rect_size.y/2)
	score_notification.set_score(score_value)
	
	pass

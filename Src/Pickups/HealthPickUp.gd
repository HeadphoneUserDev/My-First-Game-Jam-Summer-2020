extends Area2D

func _ready():
	
	randomize()
	
	pass

func _on_HealthPickUp_body_entered(body):
	
	if body.is_in_group("Player_01") and body.healthFull == false:
		queue_free()
	pass

extends Area2D

func _ready():
	
	randomize()
	
	pass


func _on_ReloadPickup_body_entered(body):
	
	if body.is_in_group("Player_01"):
		queue_free()
	
	pass

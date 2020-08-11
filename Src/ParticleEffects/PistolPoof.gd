extends Node2D

func _process(_delta):
	
	if $Particles2D.emitting == false:
		yield(get_tree().create_timer(0.9), "timeout")
		queue_free()
	
	pass

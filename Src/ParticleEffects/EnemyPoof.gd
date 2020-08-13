extends Node2D

func _ready():
	
	$AnimationPlayer.play("poof")
	
	pass

func _process(delta):
	
#	if $Particles2D.emitting == false:
#		yield(get_tree().create_timer(0.9), "timeout")
#		queue_free()
	
	pass

func poof_finished():
	
	queue_free()
	
	pass

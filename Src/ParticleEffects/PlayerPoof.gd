extends Node2D

var used = false

func _ready():
	
	$AnimationPlayer.play("poof")
	
	pass

func _process(delta):
	
#	if used == false:
#		if $Particles2D.emitting == false:
#			used = true
#			yield(get_tree().create_timer(0.9), "timeout")
#			queue_free()
	
#	if used == false:
#		$AnimationPlayer.play("poof")
	
	pass

func poof_finished():
	
	queue_free()
	
	pass

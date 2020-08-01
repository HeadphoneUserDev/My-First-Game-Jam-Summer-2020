extends Node2D

func _ready():
	pass

func _process(delta):
	
	modulate.a
	
	pass

func set_score(value: int) -> void:
	
	$Label.text = "+" + str(value)
	
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	
	dead()
	print("animationFinish")
	
	pass

func dead():
	
	queue_free()
	
	pass

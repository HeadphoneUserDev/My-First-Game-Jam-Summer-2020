extends Area2D

var explode = preload("res://Src/ParticleEffects/ReloadPickedUp.tscn")

var entered = false

func _ready():
	
	randomize()
	anim_play()
	
	pass

func _process(delta):
	
	if entered == false:
		var explode_instance = Global.instance_node(explode, global_position, Global.node_creation_parent)
		explode_instance.get_node("Particles2D").emitting = true
		entered = true
	
	pass

func _on_ReloadPickup_body_entered(body):
	
	if body.is_in_group("Player_01"):
		var explode_instance = Global.instance_node(explode, global_position, Global.node_creation_parent)
		explode_instance.get_node("Particles2D").emitting = true
		queue_free()
	
	pass

func anim_play():
	
	$AnimationPlayer.play("anim")
	
	pass

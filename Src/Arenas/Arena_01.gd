extends Node2D

#var warpTeleport = $Warp.get_position()
#var playerPosition = $Player_01.get_position()

func _ready():
	
	Global.node_creation_parent = self
	
	pass

func _exit_tree():
	
	Global.node_creation_parent = null
	
	pass

#func _process(delta):
#
#	if Input.is_action_just_pressed("warp"):
#		playerPosition.position = Vector2(warpTeleport)
#
#	pass

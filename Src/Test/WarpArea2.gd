extends Area2D

signal teleport2_teleported

export(NodePath) var teleport_target = null

var player_in_teleport2 = false
var player_in_teleport2_allow = true
var teleported = false

func _process(delta):
	
#	if Input.is_action_just_pressed("warp") and teleported == false:
#		get_tree().call_group("Player_01", "teleport_to", get_node(teleport_target).position)
	
	teleport()
	
	pass

func teleport():
	
	if player_in_teleport2 == true and teleported == false:
		get_tree().call_group("Player_01", "teleport_to", get_node(teleport_target).position)
		teleported = true
		player_in_teleport2 = false
		emit_signal("teleport2_teleported")
	
	pass

func teleported():
	
	player_in_teleport2_allow = false
	
	pass


func _on_WarpArea2_body_entered(body):
	
	if body.is_in_group("Player_01"):
		if player_in_teleport2_allow == true:
			player_in_teleport2 = true
		teleport()
	print("entered")
	
	pass


func _on_WarpArea2_body_exited(body):
	
	if body.is_in_group("Player_01"):
		player_in_teleport2 = false
		teleported = false
		player_in_teleport2_allow = true
	print("exited")
	
	pass

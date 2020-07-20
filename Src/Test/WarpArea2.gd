extends Area2D

var speed = 300
var stop = 0
var friction = 100

var velocity = Vector2(1, 0)

signal teleport2_teleported

var player_in_teleport2 = false
var player_in_teleport2_allow = true
var teleported = false
var enabled = false
var moving = false
var look_once = true

onready var warpArea = get_parent().get_node("WarpArea")

func _ready():
	
	self.connect("teleport2_teleported", warpArea, "teleported1")
	
	pass

func _process(delta):
	
	teleport()
	
	if Input.is_action_just_pressed("place"):
		enabled = true
	
	if teleported == true:
		queue_free()
	
	pass

func teleport():
	
	if player_in_teleport2 == true and teleported == false:
		get_tree().call_group("Player_01", "teleport_to", warpArea.global_position)
		teleported = true
		player_in_teleport2 = false
		emit_signal("teleport2_teleported")
	
	pass

func teleported2():
	
	player_in_teleport2_allow = false
	
	pass


func _on_WarpArea2_body_entered(body):
	
	if body.is_in_group("Player_01") and enabled == true:
		player_in_teleport2 = true
	print("entered")
	
	pass


func _on_WarpArea2_body_exited(body):
	
#	if body.is_in_group("Player_01"):
#		player_in_teleport2 = false
#		teleported = false
#		player_in_teleport2_allow = true
#	print("exited")
	
	pass


extends Area2D

var speed = 750
var stop = 0
var friction = 5

var velocity = Vector2(1, 0)

signal teleport1_teleported

var player_in_teleport1 = false
var player_in_teleport1_allow = true
var teleported = false
var enabled = false
var moving = true
var look_once = true

onready var warpArea2 = get_parent().get_node("WarpArea2")
onready var player_01 = get_parent().get_node("Player_01")

func _ready():
	
	self.connect("teleport1_teleported", warpArea2, "teleported2")
	$LifeTime.start()
	
	pass

func _process(delta):
	
	moving1(delta)
	stop1(delta)
	teleport()
	
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	
	if Input.is_action_just_pressed("place"):
		moving = false
		enabled = true
	
	
	if player_in_teleport1_allow == false:
		queue_free()
	
	pass

func moving1(delta):
	
	if moving == true:
		global_position += velocity.rotated(rotation) * speed * delta
		
	
	pass

func stop1(delta):
	
	if moving == false:
		global_position += velocity.rotated(rotation) * speed * delta
		speed = lerp(speed, stop, delta * 5)
	
	pass

func teleport():
	
	if player_in_teleport1 == true and teleported == false:
		get_tree().call_group("Player_01", "teleport_to", warpArea2.global_position)
		teleported = true
		player_in_teleport1 = false
		emit_signal("teleport1_teleported")
	
	pass

func teleported1():
	
	player_in_teleport1_allow = false
	print("connected")
	
	pass

func _on_WarpArea_body_entered(body):
	
	if body.is_in_group("Player_01") and enabled == true:
		if player_in_teleport1_allow == true:
			player_in_teleport1 = true
		teleport()
	print("entered")
	
	
	pass


func _on_WarpArea_body_exited(body):
	
	if body.is_in_group("Player_01"):
		player_in_teleport1 = false
		teleported = false
		player_in_teleport1_allow = true
	print("exited")
	
	pass

func cancel():
	
	queue_free()
	
	pass


func _on_LifeTime_timeout():
	
	moving = false
	
	pass

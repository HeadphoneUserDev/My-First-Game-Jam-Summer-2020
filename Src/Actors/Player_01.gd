extends KinematicBody2D

export var ACCELERATION = 1200
export var MAX_SPEED = 250
export var FRICTION = 1000
var camera_offset = Vector2(200, 100)

var velocity = Vector2.ZERO
var hp = 5
var knockback = Vector2.ZERO

var bullet = preload("res://Src/Bullets/PlayerBullet_01.tscn")
var machineGun_bullet = preload("res://Src/Bullets/MachineGunBullet_01.tscn")
var bazookaBullet = preload("res://Src/Bullets/BazookaBullet_01.tscn")
var warpDevice = preload("res://Src/Mechanics or something/WarpDevice.tscn")

var can_shoot = true
var is_dead = false
var chosen_weapon1 = true
var chosen_weapon2 = false
var chosen_weapon3 = false
var chosen_weapon4 = false

onready var rng = RandomNumberGenerator.new()
onready var camera = get_parent().get_node("Camera2D")

func _ready():
	
	if is_dead == false:
		Global.player = self
		print("self")
	elif is_dead == true:
		Global.player = null
		print("null")
	rng.randomize()
	
	pass

func _exit_tree():
	
	Global.player = null
	
	pass

func _physics_process(delta):
	
	knockback = knockback.move_toward(Vector2.ZERO, 1000 * delta)
	knockback = move_and_slide(knockback)
	
	if hp <= 0:
		is_dead = true
		visible = false
		_exit_tree()
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().reload_current_scene()
	
	if is_dead == false:
		move_state(delta)
	
	aim_zoom()
	
	pass

func move_state(delta):
	
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("weapon_change1"):
		
		if chosen_weapon1 == false:
			chosen_weapon1 = true
			chosen_weapon2 = false
			chosen_weapon3 = false
			chosen_weapon4 = false
			
	elif Input.is_action_just_pressed("weapon_change2"):
		
		if chosen_weapon2 == false:
			chosen_weapon2 = true
			chosen_weapon1 = false
			chosen_weapon3 = false
			chosen_weapon4 = false
			
	elif Input.is_action_just_pressed("weapon_change3"):
		
		if chosen_weapon3 == false:
			chosen_weapon3 = true
			chosen_weapon1 = false
			chosen_weapon2 = false
			chosen_weapon4 = false
			
	elif Input.is_action_just_pressed("weapon_change4"):
		
		if chosen_weapon4 == false:
			chosen_weapon4 = true
			chosen_weapon1 = false
			chosen_weapon2 = false
			chosen_weapon3 = false
			
	pistol_shoot()
	machineGun_shoot()
	bazooka_shoot()
	warp_teleport()
	
	pass

func pistol_shoot():
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon1 == true:
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		$ReloadSpeed.wait_time = 0.5
		$ReloadSpeed.start()
		can_shoot = false
	
	pass

func machineGun_shoot():
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon2 == true:
		Global.instance_node(machineGun_bullet, global_position, Global.node_creation_parent)
		$ReloadSpeed.wait_time = 0.1
		$ReloadSpeed.start()
		can_shoot = false
	
	pass

func bazooka_shoot():
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon3 == true:
		Global.instance_node(bazookaBullet, global_position, Global.node_creation_parent)
		$ReloadSpeed.wait_time = 0.7
		$ReloadSpeed.start()
		can_shoot = false
	
	pass

func warp_teleport():
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon4 == true:
		Global.instance_node(warpDevice, global_position, Global.node_creation_parent)
		$ReloadSpeed.wait_time = 0.4
		$ReloadSpeed.start()
		can_shoot = false
	
	pass

func move():
	
	velocity = move_and_slide(velocity)
	
	pass

func aim_zoom():
	
	if Input.is_action_pressed("aim"):
		#Calculate the difference between player position and mouse position
		var diff = get_viewport().get_mouse_position() - get_global_transform_with_canvas().origin
		#set the offset to a fixed distance from the player
		diff = diff / diff.length() * camera_offset
		#update the camera offset
		camera.offset = diff
		camera.zoom = Vector2(0.5, 0.5)
		
	else:
		if Input.is_action_just_released("aim"):
			var diff = get_viewport().get_mouse_position() - get_global_transform_with_canvas().origin
			diff = diff / diff.length() * camera_offset * 0
			camera.offset = diff
			camera.zoom = Vector2(0.7, 0.7)

func _on_ReloadSpeed_timeout():
	
	can_shoot = true
	
	pass 


func _on_Hitbox_area_entered(area):
	
	if area.is_in_group("Enemy"): 
		knockback = area.knockback_vector * 350
		modulate = Color("ff0000")
		hp -= 1
		$GotHitTimer.start()
		
		var weapon_choice = rng.randi_range(1, 4)
		chosen_weapon1 = weapon_choice == 1
		chosen_weapon2 = weapon_choice == 2
		chosen_weapon3 = weapon_choice == 3
		chosen_weapon4 = weapon_choice == 4
		print(weapon_choice)
	
	if area.is_in_group("WeaponChange"):
		var weapon_choice = rng.randi_range(1, 4)
		chosen_weapon1 = weapon_choice == 1
		chosen_weapon2 = weapon_choice == 2
		chosen_weapon3 = weapon_choice == 3
		chosen_weapon4 = weapon_choice == 4
		print(weapon_choice)
	
	pass


func _on_GotHitTimer_timeout():
	
	modulate = Color.white
	
	pass

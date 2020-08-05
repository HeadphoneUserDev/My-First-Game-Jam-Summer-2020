extends KinematicBody2D

signal healthChange
signal hit

export var ACCELERATION = 1200
export var MAX_SPEED = 0
export var AIM_SPEED = 0
export var FRICTION = 1000
var camera_offset = Vector2(200, 100)

var velocity = Vector2.ZERO
var hp 
var max_hp = 5
var knockback = Vector2.ZERO

var bullet = preload("res://Src/Bullets/PlayerBullet_01.tscn")
var machineGun_bullet = preload("res://Src/Bullets/MachineGunBullet_01.tscn")
var bazookaBullet = preload("res://Src/Bullets/BazookaBullet_01.tscn")
var warpArea = preload("res://Src/Test/WarpArea.tscn")
var warpArea2 = preload("res://Src/Test/WarpArea2.tscn")

var pistolReload = 0.5
var machinegunReload = 0.1
var bazookaReload = 0.8

var aim_weight = 0

var can_shoot = true
var is_dead = false
var is_aiming = false
var warpArea_used = false
var warpArea2_used = true
var healthFull = true
var stun = false
var chosen_weapon1 = true
var chosen_weapon2 = false
var chosen_weapon3 = false
var chosen_weapon4 = false

onready var rng = RandomNumberGenerator.new()
onready var camera = get_parent().get_node("Camera2D")
onready var healthPickup = get_parent().get_node("HealthPickUp")

func _ready():
	
	if is_dead == false:
		Global.player = self
		print("self")
	elif is_dead == true:
		Global.player = null
		print("null")
	rng.randomize()
	
	hp = max_hp
	print(hp)
	
	self.connect("healthFull", healthPickup, "health_full")
	emit_signal("healthChange", hp * 100/max_hp)
	
	pass

func _exit_tree():
	
	Global.player = null
	
	pass

func _physics_process(delta):
	
	knockback = knockback.move_toward(Vector2.ZERO, 1000 * delta)
	knockback = move_and_slide(knockback)
	
	if hp <= 4:
		healthFull = false
	
	if hp <= 0:
		is_dead = true
		visible = false
		
	
	if is_dead == false:
		move_state(delta)
	elif is_dead == true:
		dead_state()
	
#	aim_zoom()
	
	pass

func move_state(delta):
	
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO and stun == false:
		if is_aiming == false:
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(input_vector * AIM_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#		if stun == true:
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
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
#
	pistol_shoot()
	machineGun_shoot()
	bazooka_shoot()
	warp_teleport()
	
	position.x = clamp(position.x, camera.limit_left, camera.limit_right)
	position.y = clamp(position.y, camera.limit_top, camera.limit_bottom)
	
	pass

func dead_state():
	
	_exit_tree()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().reload_current_scene()
	
	pass

func teleport_to(target_pos):
	
	position = target_pos
	
	pass

func pistol_shoot():
	
	if chosen_weapon1 == true:
		MAX_SPEED = 250
		AIM_SPEED = 175
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon1 == true and stun == false:
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		$ReloadSpeed.wait_time = pistolReload
		$ReloadSpeed.start()
		can_shoot = false
		is_aiming = true
	elif Input.is_action_just_released("click"):
		is_aiming = false
	
	pass

func machineGun_shoot():
	
	if chosen_weapon2 == true:
		MAX_SPEED = 200
		AIM_SPEED = 125
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon2 == true and stun == false:
		Global.instance_node(machineGun_bullet, global_position, Global.node_creation_parent)
		$ReloadSpeed.wait_time = machinegunReload
		$ReloadSpeed.start()
		can_shoot = false
		is_aiming = true
	elif Input.is_action_just_released("click"):
		is_aiming = false
	
	pass

func bazooka_shoot():
	
	if chosen_weapon3 == true:
		MAX_SPEED = 150
		AIM_SPEED = 50
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon3 == true and stun == false:
		Global.instance_node(bazookaBullet, global_position, Global.node_creation_parent)
		$ReloadSpeed.wait_time = bazookaReload
		$ReloadSpeed.start()
		can_shoot = false
		is_aiming = true
	elif Input.is_action_just_released("click"):
		is_aiming = false
	
	pass

func warp_teleport():
	
	if chosen_weapon4 == true:
		MAX_SPEED = 250
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon4 == true and warpArea_used == false and stun == false:
		Global.instance_node(warpArea, global_position, Global.node_creation_parent)
		warpArea_used = true
		$ReloadSpeed.wait_time = 0.0005
		$ReloadSpeed.start()
		can_shoot = false
		
		
	elif Input.is_action_pressed("place") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon4 == true and warpArea_used == true and stun == false:
		Global.instance_node(warpArea2, global_position, Global.node_creation_parent)
		warpArea_used = false
		
	
	pass

func move():
	
	velocity = move_and_slide(velocity)
	
	pass


func _on_ReloadSpeed_timeout():
	
	can_shoot = true
	
	pass 


func _on_Hitbox_area_entered(area):
	
	if is_dead == false:
		if area.is_in_group("Enemy"): 
			knockback = area.knockback_vector * 350
			modulate = Color("ff0000")
			hp -= 1
			emit_signal("healthChange", hp * 100/max_hp)
			emit_signal("hit")
			stun = true
			$GotHitTimer.start()
			print(hp)
			
			var weapon_choice = rng.randi_range(1, 4)
			chosen_weapon1 = weapon_choice == 1
			chosen_weapon2 = weapon_choice == 2
			chosen_weapon3 = weapon_choice == 3
			chosen_weapon4 = weapon_choice == 4
			
		elif area.is_in_group("Health") and hp != 5:
			hp += 2
			hp = clamp(hp, 0, max_hp)
			emit_signal("healthChange", hp * 100/max_hp)
			print(hp)
			
			if hp == 5:
				yield(get_tree().create_timer(0.2), "timeout")
				healthFull = true
			
		elif area.is_in_group("WeaponPickUp"):
			var weapon_choice = rng.randi_range(1, 4)
			chosen_weapon1 = weapon_choice == 1
			chosen_weapon2 = weapon_choice == 2
			chosen_weapon3 = weapon_choice == 3
			chosen_weapon4 = weapon_choice == 4
			print(weapon_choice)
		elif area.is_in_group("ReloadUpgrade"):
			if chosen_weapon1 == true:
				pistolReload *= 0.85
			elif chosen_weapon2 == true:
				machinegunReload *= 0.98
			elif chosen_weapon3 == true:
				bazookaReload *= 0.92
		
	
	pass


func _on_GotHitTimer_timeout():
	
	modulate = Color.white
	stun = false
	
	pass

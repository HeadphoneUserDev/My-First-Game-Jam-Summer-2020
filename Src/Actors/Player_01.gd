extends KinematicBody2D

signal healthChange
signal hit
signal expo_dead
signal weapon_change(value)

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
var bazookaBoost = preload("res://Src/ParticleEffects/BazookaBoost.tscn")
var poof = preload("res://Src/ParticleEffects/PlayerPoof.tscn")

var pistolReload = 0.5
var machinegunReload = 0.1
var bazookaReload = 0.8

var aim_weight = 0

var can_shoot = true
var is_dead = false
var is_aiming = false
var sceneReload = true
var start_deadTimer = false
var warpArea_used = false
var warpArea2_used = true
var healthFull = true
var stun = false
var got_hit = false
var death_anim_played = false
var is_using_weapon = false
var picked_up = false
var weaponDisplay_connected = false
var healthAudio = false
var chosen_weapon1 = true
var chosen_weapon2 = false
var chosen_weapon3 = false
var chosen_weapon4 = false
var signaled = false


onready var rng = RandomNumberGenerator.new()
onready var camera = get_parent().get_node("Camera2D")
onready var healthPickup = get_parent().get_node("HealthPickUp")
onready var screenShake = get_parent().get_node("../Camera2D/ScreenShake")
onready var deadTimer = $DeadTimer
onready var bazookaGuide = $BazookaGuide

var array = [1, 2, 3, 4]
var lastNum = 1
var num

func _ready():
	
	randomize()
	
	if is_dead == false:
		Global.player = self
		print("self")
	elif is_dead == true:
		Global.player = null
		print("null")
	
	rng.randomize()
#	array.shuffle()
	
	hp = max_hp
	print(hp)
	
	self.connect("expo_dead", screenShake, "start", [0.2, 15, 16, 2])
	self.connect("healthFull", healthPickup, "health_full")
	emit_signal("healthChange", hp * 100/max_hp)
#
#	if is_dead == true:
#		deadTimer.start()
		
	
	
	pass

func _exit_tree():
	
	Global.player = null
#	if sceneReload == false:
#		get_tree().reload_current_scene()
	
	pass

func _physics_process(delta):
	
	if signaled == false:
		if chosen_weapon1 == true:
			emit_signal("weapon_change", 1)
			signaled = true
		elif chosen_weapon2 == true:
			emit_signal("weapon_change", 2)
			signaled = true
		elif chosen_weapon3 == true:
			emit_signal("weapon_change", 3)
			signaled = true
		elif chosen_weapon4 == true:
			emit_signal("weapon_change", 4)
			signaled = true
	
	knockback = knockback.move_toward(Vector2.ZERO, 1000 * delta)
	knockback = move_and_slide(knockback)
	
	if hp <= 4:
		healthFull = false
	
	if hp <= 0:
		is_dead = true
		
	
	if is_dead == false:
		move_state(delta)
	else:
		_exit_tree()
		$CollisionShape2D.disabled = true
		$Hitbox/CollisionShape2D.disabled = true
		$AnimatedSprite.playing = false
		if death_anim_played == false:
			$AnimationPlayer.play("Death_anim")
			death_anim_played = true
	
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
			if chosen_weapon3 == false:
				$AnimatedSprite.play("Run")
			else:
				$AnimatedSprite.play("BazookaAim")
		else:
			velocity = velocity.move_toward(input_vector * AIM_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		if chosen_weapon3 == false and is_using_weapon == false and got_hit == false:
			$AnimatedSprite.play("Idle")
		elif chosen_weapon1 and got_hit == false:
			$AnimatedSprite.play("PistolAim")
		elif chosen_weapon2 and got_hit == false:
			$AnimatedSprite.play("MachineGunAim")
		elif chosen_weapon3 and got_hit == false:
			$AnimatedSprite.play("BazookaAim")
		elif got_hit and is_dead == false:
			$AnimatedSprite.play("Hit")
#			$AnimationPlayer.play("Death_anim")
#		if stun == true:
#			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("weapon_change1"):
		
		signaled = false
		if chosen_weapon1 == false:
			chosen_weapon1 = true
			chosen_weapon2 = false
			chosen_weapon3 = false
			chosen_weapon4 = false

	elif Input.is_action_just_pressed("weapon_change2"):
		
		signaled = false
		if chosen_weapon2 == false:
			chosen_weapon2 = true
			chosen_weapon1 = false
			chosen_weapon3 = false
			chosen_weapon4 = false

	elif Input.is_action_just_pressed("weapon_change3"):
		
		signaled = false
		if chosen_weapon3 == false:
			chosen_weapon3 = true
			chosen_weapon1 = false
			chosen_weapon2 = false
			chosen_weapon4 = false

	elif Input.is_action_just_pressed("weapon_change4"):
		
		signaled = false
		if chosen_weapon4 == false:
			chosen_weapon4 = true
			chosen_weapon1 = false
			chosen_weapon2 = false
			chosen_weapon3 = false
	
	look_at(get_global_mouse_position())
	bazookaGuide.look_at(get_global_mouse_position())
	
	pistol_shoot()
	machineGun_shoot()
	bazooka_shoot()
	warp_teleport()
	
	position.x = clamp(position.x, camera.limit_left, camera.limit_right)
	position.y = clamp(position.y, camera.limit_top, camera.limit_bottom)
	
	pass

func dead_state():
	
#
#	start_deadTimer = true
	yield(get_tree().create_timer(1), "timeout")
	get_tree().reload_current_scene()
	Global.points = 0
	
	
	pass

func teleport_to(target_pos):
	
	position = target_pos
	
	pass

func pistol_shoot():
	
	if chosen_weapon1 == true:
		MAX_SPEED = 250
		AIM_SPEED = 175
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon1 == true and stun == false:
		Global.instance_node(bullet, $PistolGuide.global_position, Global.node_creation_parent)
		$ShootAudio.play()
		$ReloadSpeed.wait_time = pistolReload
		$ReloadSpeed.start()
		$AnimatedSprite.play("PistolAim")
		can_shoot = false
		is_aiming = true
		is_using_weapon = true
	elif Input.is_action_just_released("click"):
		is_aiming = false
		is_using_weapon = false
	
	pass

func machineGun_shoot():
	
	if chosen_weapon2 == true:
		MAX_SPEED = 200
		AIM_SPEED = 125
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon2 == true and stun == false:
		Global.instance_node(machineGun_bullet, $MachineGunGuide.global_position, Global.node_creation_parent)
		$ShootAudio.play()
		$ReloadSpeed.wait_time = machinegunReload
		$ReloadSpeed.start()
		$AnimatedSprite.play("MachineGunAim")
		can_shoot = false
		is_aiming = true
		is_using_weapon = true
	elif Input.is_action_just_released("click"):
		is_aiming = false
		is_using_weapon = false
	
	pass

func bazooka_shoot():
	
	if chosen_weapon3 == true:
		MAX_SPEED = 150
		AIM_SPEED = 50
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon3 == true and stun == false:
		Global.instance_node(bazookaBullet, bazookaGuide.global_position, Global.node_creation_parent)
		$BazookaLaunch.play()
		$ReloadSpeed.wait_time = bazookaReload
		$ReloadSpeed.start()
		can_shoot = false
		is_aiming = true
		is_using_weapon = true
	elif Input.is_action_just_released("click"):
		is_aiming = false
		is_using_weapon = false
	
	pass

func warp_teleport():
	
	if chosen_weapon4 == true:
		MAX_SPEED = 250
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot and is_dead == false and chosen_weapon4 == true and warpArea_used == false and stun == false:
		Global.instance_node(warpArea, global_position, Global.node_creation_parent)
		$WarpDeviceThrow.play()
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
			if hp <= 1:
				$DeadHit.play()
			else:
				$Hit.play()
			signaled = false
			knockback = area.knockback_vector * 350
			modulate = Color("0000ff")
			hp -= 1
			emit_signal("healthChange", hp * 100/max_hp)
			emit_signal("hit")
			got_hit = true
			stun = true
			$GotHitTimer.start()
			print(hp)
			
			var weapon_choice
			
			array.erase(lastNum)
			
			array.shuffle()
			num = array.back()
			array.append(lastNum)
			weapon_choice = num
			lastNum = num
			array.erase(num)
			print(lastNum)
			print(array)
			
			
			chosen_weapon1 = weapon_choice == 1
			chosen_weapon2 = weapon_choice == 2
			chosen_weapon3 = weapon_choice == 3
			chosen_weapon4 = weapon_choice == 4
			
			
			
		elif area.is_in_group("Health") and hp != 5:
			
			if hp <= 4:
				healthAudio = false
			else:
				healthAudio = true
			
			hp += 2
			hp = clamp(hp, 0, max_hp)
			emit_signal("healthChange", hp * 100/max_hp)
			print(hp)
			
			if healthAudio == false:
				$HealthPickupAudio.play()
			else:
				$HealthPickupAudio.stop()
			
			if hp == 5:
				yield(get_tree().create_timer(0.2), "timeout")
				healthFull = true
				healthAudio = true
			
		elif area.is_in_group("WeaponPickUp"):
			
			$WeaponPickupAudio.play()
			signaled = false
			
#			var chosenWeapon
#			var lastWeapon
#			var weapon_choice = rng.randi_range(1, 4)
#			lastWeapon = weapon_choice
#
#			while lastWeapon == weapon_choice:
#				weapon_choice = rng.randi_range(1, 4)
			
#			while weapon_choice == 1 or weapon_choice == 2 or weapon_choice == 3 or weapon_choice == 4:
#				weapon_choice = rng.randi_range(1, 4)
			
			
			var weapon_choice
			
			array.erase(lastNum)
			
			array.shuffle()
			num = array.back()
			array.append(lastNum)
			weapon_choice = num
			lastNum = num
			array.erase(num)
			print(lastNum)
			print(array)
			
			
			chosen_weapon1 = weapon_choice == 1
			chosen_weapon2 = weapon_choice == 2
			chosen_weapon3 = weapon_choice == 3
			chosen_weapon4 = weapon_choice == 4
			
#			var lastWeapon
#			var weapon_choice:int = randi() % array.size() + 1
#			lastWeapon = weapon_choice
#			print(weapon_choice)
			
			
		elif area.is_in_group("ReloadUpgrade"):
			$ReloadAudio.play()
			if chosen_weapon1 == true:
				pistolReload *= 0.9
			elif chosen_weapon2 == true:
				machinegunReload *= 0.98
			elif chosen_weapon3 == true:
				bazookaReload *= 0.95
		
	
	pass


func _on_GotHitTimer_timeout():
	
	modulate = Color.white
	stun = false
	got_hit = false
	
	pass


func _on_DeadTimer_timeout():
	
	print("yep")
	sceneReload = false
	_exit_tree()
	
	pass

func screen_shake():
	
	emit_signal("expo_dead")
	var poof_instance = Global.instance_node(poof, global_position, Global.node_creation_parent)
	poof_instance.get_node("Particles2D").emitting = true
	
	pass

func explode1():
	
	$Explode1.play()
	
	pass

func explode2():
	
	$Explode2.play()
	
	pass

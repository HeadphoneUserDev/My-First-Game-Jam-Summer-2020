extends KinematicBody2D

export var ACCELERATION = 1200
export var MAX_SPEED = 250
export var FRICTION = 1000

var velocity = Vector2.ZERO

var bullet = preload("res://Src/Bullets/PlayerBullet_01.tscn")
var machineGun_bullet = preload("res://Src/Bullets/MachineGunBullet_01.tscn")
var bazookaBullet = preload("res://Src/Bullets/BazookaBullet_01.tscn")

var can_shoot = true
var is_dead = false
var chosen_weapon1 = true
var chosen_weapon2 = false
var chosen_weapon3 = false

onready var rng = RandomNumberGenerator.new()

func _ready():
	
	Global.player = self
	rng.randomize()
	
	pass

func _exit_tree():
	
	Global.player = null
	
	pass

func _physics_process(delta):
	
	if is_dead == false:
		move_state(delta)
	
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
			
	elif Input.is_action_just_pressed("weapon_change2"):
		
		if chosen_weapon2 == false:
			chosen_weapon2 = true
			chosen_weapon1 = false
			chosen_weapon3 = false
			
	elif Input.is_action_just_pressed("weapon_change3"):
		
		if chosen_weapon3 == false:
			chosen_weapon3 = true
			chosen_weapon1 = false
			chosen_weapon2 = false
	
	pistol_shoot()
	machineGun_shoot()
	bazooka_shoot()
	
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

func move():
	
	velocity = move_and_slide(velocity)
	
	pass


func _on_ReloadSpeed_timeout():
	
	can_shoot = true
	
	pass 


func _on_Hitbox_area_entered(area):
	
	if area.is_in_group("Enemy"):
		is_dead = true
		visible = false
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().reload_current_scene()
	
	if area.is_in_group("WeaponChange"):
		var weapon_choice = rng.randi_range(1, 3)
		chosen_weapon1 = weapon_choice == 1
		chosen_weapon2 = weapon_choice == 2
		chosen_weapon3 = weapon_choice == 3
		print(weapon_choice)
	
	pass

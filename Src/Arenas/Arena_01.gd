extends Node2D

onready var rng = RandomNumberGenerator.new()
onready var weaponPickUptimer = $WeaponPickUpTimer
onready var healthPickUptimer = $HealthPickUpTimer
onready var camera = $Camera2D

var enemy_01 = preload("res://Src/Actors/Enemy_01.tscn")
var weaponPickup = preload("res://Src/Pickups/WeaponPickUp.tscn")
var healthPickup = preload("res://Src/Pickups/HealthPickUp.tscn")

var weaponChosentimer
var healthChosentimer

func _ready():
	
	Global.node_creation_parent = self
	rng.randomize()
	weaponPickUptimer.start()
	healthPickUptimer.start()
	
	set_camera_limits()
	
	pass

func _process(delta):
	
	weaponChosentimer = rng.randi_range(30, 60)
	weaponPickUptimer.wait_time = weaponChosentimer
	
	healthChosentimer = rng.randi_range(15, 30)
	healthPickUptimer.wait_time = healthChosentimer
	
	pass

func _exit_tree():
	
	Global.node_creation_parent = null
	
	pass

func set_camera_limits():
	
	var map_limits = get_viewport_rect()
	$Camera2D.limit_left = map_limits.position.x
	$Camera2D.limit_right = map_limits.end.x
	$Camera2D.limit_top = map_limits.position.y
	$Camera2D.limit_bottom = map_limits.end.y
	
	pass

func _on_EnemySpawnTimer_timeout():
	
	var enemy_position = Vector2(rand_range(-50, 1330), rand_range(-50, 770))
	
	while enemy_position.x < 1280 and enemy_position.x > 0 and enemy_position.y < 720 and enemy_position.y > 0:
		enemy_position = Vector2(rand_range(-50, 1330), rand_range(-50, 770))
	
	Global.instance_node(enemy_01, enemy_position, self)
	
	pass


func _on_WeaponPickUpTimer_timeout():
	
	var weaponPickupPosition = Vector2(rand_range(0, 1280), rand_range(0, 720))
	
	while weaponPickupPosition.x > 1280 and weaponPickupPosition.x < 0 and weaponPickupPosition.y > 720 and weaponPickupPosition.y < 0:
		weaponPickupPosition = Vector2(rand_range(0, 1280), rand_range(0, 720))
	
	Global.instance_node(weaponPickup, weaponPickupPosition, self)
	
	pass


func _on_HealthPickUpTimer_timeout():
	
	var healthPosition = Vector2(rand_range(0, 1280), rand_range(0, 720))
	
	while healthPosition.x > 1280 and healthPosition.x < 0 and healthPosition.y > 720 and healthPosition.y < 0:
		healthPosition = Vector2(rand_range(0, 1280), rand_range(0, 720))
	
	Global.instance_node(healthPickup, healthPosition, self)
	
	pass

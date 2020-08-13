extends Node2D

onready var rng = RandomNumberGenerator.new()
onready var weaponPickUptimer = $WeaponPickUpTimer
onready var healthPickUptimer = $HealthPickUpTimer
onready var upgradePickuptimer = $UpgradePickupTimer
onready var enemySpawntimer = $EnemySpawnTimer
onready var camera = $Camera2D

var enemy_01 = preload("res://Src/Actors/Enemy_01.tscn")
var weaponPickup = preload("res://Src/Pickups/WeaponPickUp.tscn")
var healthPickup = preload("res://Src/Pickups/HealthPickUp.tscn")

var reloadPickup = preload("res://Src/Pickups/ReloadPickup.tscn")
var powerPickup = preload("res://Src/Pickups/PowerPickup.tscn")


var weaponChosentimer
var healthChosentimer
var upgradeChosentimer

var enemyLimit = 10
var enemyCount = 0

var minweaponTimer = 30
var maxweaponTimer = 60
var minhealthTimer = 15
var maxhealthTimer = 30
var minupgradeTimer = 10
var maxupgradeTimer = 20

var checked = false
var camera_changed = false

func _ready():
	
#	Input.set_custom_mouse_cursor(load("res://MFGJ Sprites/Cursur/WarpDevice2.png"), Input.CURSOR_ARROW, Vector2(16, 16))
	
	Global.node_creation_parent = self
	rng.randomize()
	weaponPickUptimer.start()
	healthPickUptimer.start()
	upgradePickuptimer.start()
	
	set_camera_limits()
	
	pass

func _process(_delta):
	
	if Input.is_action_just_pressed("camera_change") and camera_changed == false:
#		$Camera2D.current = false
		$Camera2D.zoom.x = 1
		$Camera2D.zoom.y = 1
		camera_changed = true
	elif Input.is_action_just_pressed("camera_change") and camera_changed == true:
#		$Camera2D.current = true
		$Camera2D.zoom.x = 0.7
		$Camera2D.zoom.y = 0.7
		camera_changed = false
	
	weaponChosentimer = rng.randi_range(minweaponTimer, maxweaponTimer)
	weaponPickUptimer.wait_time = weaponChosentimer
	
	healthChosentimer = rng.randi_range(minhealthTimer, maxhealthTimer)
	healthPickUptimer.wait_time = healthChosentimer
	
	upgradeChosentimer = rng.randi_range(minupgradeTimer, maxupgradeTimer)
	upgradePickuptimer.wait_time = upgradeChosentimer
	
	if $EnemyContainer.get_child_count() == 0 and checked == true:
		$BreakTimer.start()
		print("break")
		minweaponTimer += 25
		maxweaponTimer += 25
		minhealthTimer += 20
		maxhealthTimer += 20
		minupgradeTimer += 3
		maxupgradeTimer += 3
		enemyCount = 0
		enemyLimit += 5
		enemySpawntimer.wait_time *= 0.90
		print(enemyLimit)
		checked = false
	
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
	
	if enemyCount <= enemyLimit:
		var enemy_position = Vector2(rand_range(-50, 1330), rand_range(-50, 770))

		while enemy_position.x < 1280 and enemy_position.x > 0 and enemy_position.y < 720 and enemy_position.y > 0:
			enemy_position = Vector2(rand_range(-50, 1330), rand_range(-50, 770))

		Global.instance_node(enemy_01, enemy_position, $EnemyContainer)
		enemyCount += 1
		print(enemyCount)

		if enemyCount == enemyLimit:
			$EnemySpawnTimer.stop()
			checked = true
			
	
	pass

func _on_BreakTimer_timeout():
	
	$BreakTimer.stop()
	$EnemySpawnTimer.start()
	print("Start")
	
	pass

func _on_WeaponPickUpTimer_timeout():
	
	var weaponPickupPosition = Vector2(rand_range(50, 1230), rand_range(50, 670))
	
	while weaponPickupPosition.x > 1230 and weaponPickupPosition.x < 50 and weaponPickupPosition.y > 670 and weaponPickupPosition.y < 50:
		weaponPickupPosition = Vector2(rand_range(50, 1230), rand_range(50, 670))
	
	Global.instance_node(weaponPickup, weaponPickupPosition, self)
	
	pass


func _on_HealthPickUpTimer_timeout():
	
	var healthPosition = Vector2(rand_range(50, 1230), rand_range(50, 670))
	
	while healthPosition.x > 1230 and healthPosition.x < 50 and healthPosition.y > 670 and healthPosition.y < 50:
		healthPosition = Vector2(rand_range(50, 1230), rand_range(50, 670))
	
	Global.instance_node(healthPickup, healthPosition, self)
	
	pass

func _on_UpgradePickupTimer_timeout():
	
	var upgradePosition = Vector2(rand_range(50, 1230), rand_range(50, 670))
	
	while upgradePosition.x > 1230 and upgradePosition.x < 50 and upgradePosition.y > 670 and upgradePosition.y < 50:
		upgradePosition = Vector2(rand_range(50, 1230), rand_range(50, 670))
	
	var upgrade_choice = rng.randi_range(1, 1)
	if upgrade_choice == 1:
		Global.instance_node(reloadPickup, upgradePosition, self)
	elif upgrade_choice == 2:
		Global.instance_node(powerPickup, upgradePosition, self)
	
	
	pass

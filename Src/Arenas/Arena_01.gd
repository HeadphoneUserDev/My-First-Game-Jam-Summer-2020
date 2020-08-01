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

func _ready():
	
	Global.node_creation_parent = self
	rng.randomize()
	weaponPickUptimer.start()
	healthPickUptimer.start()
	upgradePickuptimer.start()
	
	set_camera_limits()
	
	pass

func _process(delta):
	
	weaponChosentimer = rng.randi_range(minweaponTimer, maxweaponTimer)
	weaponPickUptimer.wait_time = weaponChosentimer
	
	healthChosentimer = rng.randi_range(minhealthTimer, maxhealthTimer)
	healthPickUptimer.wait_time = healthChosentimer
	
	upgradeChosentimer = rng.randi_range(minupgradeTimer, maxupgradeTimer)
	upgradePickuptimer.wait_time = upgradeChosentimer
	
	if $EnemyContainer.get_child_count() == 0 and checked == true:
		$BreakTimer.start()
		print("break")
		minweaponTimer += 10
		maxweaponTimer += 10
		minhealthTimer += 10
		maxhealthTimer += 10
		minupgradeTimer += 2
		maxupgradeTimer += 2
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
#			
	
	pass

func _on_BreakTimer_timeout():
	
	$BreakTimer.stop()
	$EnemySpawnTimer.start()
	print("Start")
	
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

func _on_UpgradePickupTimer_timeout():
	
	var upgradePosition = Vector2(rand_range(0, 1280), rand_range(0, 720))
	
	while upgradePosition.x > 1280 and upgradePosition.x < 0 and upgradePosition.y > 720 and upgradePosition.y < 0:
		upgradePosition = Vector2(rand_range(0, 1280), rand_range(0, 720))
	
	var upgrade_choice = rng.randi_range(1, 1)
	if upgrade_choice == 1:
		Global.instance_node(reloadPickup, upgradePosition, self)
	elif upgrade_choice == 2:
		Global.instance_node(powerPickup, upgradePosition, self)
	
	
	pass

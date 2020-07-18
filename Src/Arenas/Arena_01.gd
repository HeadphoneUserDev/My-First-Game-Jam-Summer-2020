extends Node2D

#var warpTeleport = $Warp.get_position()
#var playerPosition = $Player_01.get_position()

var enemy_01 = preload("res://Src/Actors/Enemy_01.tscn")

func _ready():
	
	Global.node_creation_parent = self
	
	pass

func _exit_tree():
	
	Global.node_creation_parent = null
	
	pass

#func _process(delta):
#
#	if Input.is_action_just_pressed("warp"):
#		playerPosition.position = Vector2(warpTeleport)
#
#	pass


func _on_EnemySpawnTimer_timeout():
	
	var enemy_position = Vector2(rand_range(-50, 1330), rand_range(-50, 770))
	
	while enemy_position.x < 1280 and enemy_position.x > 0 and enemy_position.y < 720 and enemy_position.y > 0:
		enemy_position = Vector2(rand_range(-50, 1330), rand_range(-50, 770))
	
	Global.instance_node(enemy_01, enemy_position, self)
	
	pass

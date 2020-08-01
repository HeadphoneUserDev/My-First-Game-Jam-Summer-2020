extends Node
#Singleton

var node_creation_parent = null

var player = null
var enemy = null

var enemy_count = 0

func instance_node(node, location, parent):
	
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
	
	pass

func instance_object(template, position, spawner):
	
	var instance = template.instance()
	instance.enemy_id = enemy_count
	enemy_count += 1
	add_child(instance)
	
	pass

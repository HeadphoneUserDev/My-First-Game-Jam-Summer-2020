extends Line2D

var point
var target
export(NodePath) var targetPath
export var trailLength = 0

func _ready():

	set_as_toplevel(true)
#	target = get_node(targetPath)

	pass

func _physics_process(_delta):
	
	point = get_parent().global_position
	add_point(point)
	
	while get_point_count() > trailLength:
		remove_point(0)
	
	pass

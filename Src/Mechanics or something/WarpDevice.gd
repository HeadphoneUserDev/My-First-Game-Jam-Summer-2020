extends Sprite

var velocity = Vector2(1, 0)
var speed = 300

var look_once = true

func _ready():
	
	$LifeTime.start()
	
	pass

func _process(delta):
	
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	
	global_position += velocity.rotated(rotation) * speed * delta
	
	
	pass


func _on_VisibilityNotifier2D_screen_exited():
	
	queue_free()
	
	pass


func _on_LifeTime_timeout():
	
	queue_free()
	
	pass

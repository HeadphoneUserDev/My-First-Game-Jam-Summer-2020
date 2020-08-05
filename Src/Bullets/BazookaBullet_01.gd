extends Sprite

var velocity = Vector2(1, 0)
var speed = 10
var max_speed = 1000
var stop = 0

var exploded = false

var look_once = true

func _process(delta):
	
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	
	global_position += velocity.rotated(rotation) * speed * delta
#	speed *= 65 * delta
	speed = lerp(speed, max_speed, delta * 2)
	
	pass


func _on_VisibilityNotifier2D_screen_exited():
	
	queue_free()
	
	pass


func _on_AnimationPlayer_animation_finished(_anim_name):
	
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
	
	pass


func _on_DetectHitBox_body_entered(body):
	
	if body.is_in_group("Enemy"):
		if exploded == false:
			$AnimationPlayer.play("BazookaExplosion")
			velocity = Vector2.ZERO
	#		speed = lerp(speed, stop, 1)
			exploded = true
	
	pass

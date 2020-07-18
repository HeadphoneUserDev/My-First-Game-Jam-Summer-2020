extends Sprite

var velocity = Vector2(1, 0)
var speed = 10
var max_speed = 1000


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


func _on_AnimationPlayer_animation_finished(anim_name):
	
	queue_free()
	
	pass


func _on_Hitbox_area_entered(area):
	
	if area.is_in_group("Enemy"):
		$AnimationPlayer.play("BazookaExplosion")
		velocity = Vector2.ZERO
	
	pass

extends Sprite

var speed = 75
var stop = 0
var friction = 100

var velocity = Vector2()

var stun = false
var hp = 3
var some_vector = Vector2.DOWN

onready var hitBox = $Hitbox

func _ready():
	
	hitBox.knockback_vector = some_vector
	
	pass

func _process(delta):
	
	var move_vector = velocity
	
	if Global.player != null and stun == false:
		velocity = global_position.direction_to(Global.player.global_position)
		forward_movement(delta)
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.3)
	if Global.player == null and stun == true:
		stop_movement(delta)
	
	
	hitBox.knockback_vector = move_vector
	
	if hp <= 0:
		queue_free()
	
	pass

func forward_movement(delta):
	
	global_position += velocity * speed * delta
	#makes enemy move
	
	pass

func stop_movement(delta):
	
	global_position += velocity * speed * delta
	
	pass

func _on_Hitbox_area_entered(area):
	
	if area.is_in_group("EnemyDamager"):
		modulate = Color.white
		velocity = -velocity * 3
		hp -= 1
		stun = true
		$StunTimer.start()
		area.get_parent().queue_free()
		#get_parent so that not only the hitbox will queue_free
	
	if area.is_in_group("EnemyDestroyer"):
		modulate = Color.white
		velocity = -velocity * 3
		hp -= 5
		stun = true
		$StunTimer.start()
		
	
	pass


func _on_StunTimer_timeout():
	
	modulate = Color("ff0000")
	stun = false
	
	pass

extends KinematicBody2D

signal enemy_dead

var speed = 75
var stop = 0
var friction = 100

var velocity = Vector2()

var lol = false
var stun = false
var death_stun = false
var stunTimer = true
var dead = false
var movementStop = false
var pushed = false
var hp = 3
var some_vector = Vector2.DOWN
var movement_vector = Vector2()

onready var hitBox = $Hitbox
onready var sprite = $Sprite
onready var scorePoint = get_parent().get_node("../CanvasLayer/Score")

var bullet_particles = preload("res://Src/ParticleEffects/PistolPoof.tscn")

func _ready():
	
	self.connect("enemy_dead", scorePoint, "score_event")
	
	hitBox.knockback_vector = some_vector
	randomize()
	
	Global.enemy = self
	
	pass

#func _exit_tree():
#
#	Global.enemy = null
#
#	pass

func _process(delta):
	
	var move_vector = velocity
	
	if Global.player != null and stun == false and dead == false and lol == false:
		velocity = global_position.direction_to(Global.player.global_position)
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.1)
	
	if Global.player == null:
		stun = true
	
	forward_movement(delta)
	
	hitBox.knockback_vector = move_vector
	
	if hp <= 0:
		dead = true
		lol = true
		death_anim(delta)
	
	pass

func death_anim(delta):
	
	modulate = Color.white
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("enemy_dead")
	queue_free()
	#you should use an animation finish to queue_free but we're gonna use this one 4 now
	
	pass

func forward_movement(delta):
	
	global_position += velocity * speed * delta
	#makes enemy move
	
	pass

func stop_movement(delta):
	
	velocity = -velocity * 2
	velocity = lerp(velocity, Vector2(0, 0), 0.1)
	
	pass

func _on_Hitbox_area_entered(area):
	
	if dead == false:
		if area.is_in_group("EnemyDamager") and stun == false:
			sprite.modulate = Color.white
			if hp > 1:
				velocity = -velocity * 3
				stun = true
			elif hp <= 1:
				velocity = -velocity * 5
				stun = true
				stunTimer = false
			hp -= 1
			if stunTimer == true:
				$StunTimer.start()
			area.get_parent().queue_free()
			#get_parent so that not only the hitbox will queue_free
			if Global.node_creation_parent != null:
				var bullet_particles_instance = Global.instance_node(bullet_particles, global_position, Global.node_creation_parent)
				bullet_particles_instance.rotation = velocity.angle()
				bullet_particles_instance.get_node("Particles2D").emitting = true
			
		
		if area.is_in_group("EnemyDestroyer") and stun == false:
			$Sprite.modulate = Color.white
			if hp > 5:
				velocity = -velocity * 3
				stun = true
			elif hp <= 5:
				velocity = -velocity * 5
				stun = true
				stunTimer = false
			hp -= 5
			if stunTimer == true:
				$StunTimer.start()
			
	
	pass


func _on_StunTimer_timeout():
	
	sprite.modulate = Color("ff0000")
	stun = false
	
	pass

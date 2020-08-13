extends KinematicBody2D

signal enemy_dead
signal expo_dead

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
var got_hit = false
var can_look = true
var var1_used = false
var hp = 3
var some_vector = Vector2.DOWN
var movement_vector = Vector2()

onready var hitBox = $Hitbox
onready var scorePoint = get_parent().get_node("../CanvasLayer/Score")
onready var screenShake = get_parent().get_node("../Camera2D/ScreenShake")

var bullet_particles = preload("res://Src/ParticleEffects/PistolPoof.tscn")
var poof = preload("res://Src/ParticleEffects/EnemyPoof.tscn")

onready var deathTimer = $DeathTimer

func _ready():
	
	self.connect("enemy_dead", scorePoint, "score_event")
	self.connect("expo_dead", screenShake, "start", [0.2, 15, 16, 2])
	
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
	
	if Global.player != null and stun == false and dead == false and lol == false and got_hit == false:
		velocity = global_position.direction_to(Global.player.global_position)
	elif stun:
		velocity = lerp(velocity, Vector2(0, 0), 0.1)
	
	if got_hit == true:
		$AnimatedSprite.play("Hit")
		can_look = false
	
	if Global.player == null:
		stun = true
		$AnimatedSprite.play("Idle")
		can_look = false
	
	if can_look == true:
		look_at(Global.player.global_position)
	
	forward_movement(delta)
	
	hitBox.knockback_vector = move_vector
	
	if hp <= 0:
		
		$Hitbox/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		dead = true
		if var1_used == false:
			can_look = false
			lol = true
			modulate = Color.white
			$AnimatedSprite.playing = false
			$AnimationPlayer.play("Death_anim")
			var1_used = true
	
	pass

func death_anim():
	
	queue_free()
#	$DeathTimer.start() #An alternative for death animation
#	yield(get_tree().create_timer(1), "timeout")
#	#you should use an animation finish to queue_free but we're gonna use this one 4 now
#	#Will soon be replaced with death animation
	
	pass

func forward_movement(delta):
	
	global_position += velocity * speed * delta
	#makes enemy move
	if got_hit == false and dead == false:
		$AnimatedSprite.play("Run")
	
	pass

func stop_movement(_delta):
	
	velocity = -velocity * 2
	velocity = lerp(velocity, Vector2(0, 0), 0.1)
	
	pass

func _on_Hitbox_area_entered(area):
	
	if dead == false:
		if area.is_in_group("EnemyDamager") and stun == false:
			modulate = Color("ff0000")
			if hp > 1:
				$HitAudio.play()
				velocity = -velocity * 3
				stun = true
				got_hit = true
			elif hp <= 1:
				$EnemyDead.play()
				velocity = -velocity * 5
				stun = true
				stunTimer = false
			hp -= 1
			if stunTimer == true:
				$StunTimer.start()
				got_hit = true
			area.get_parent().queue_free()
			#get_parent so that not only the hitbox will queue_free
			if Global.node_creation_parent != null:
				var bullet_particles_instance = Global.instance_node(bullet_particles, global_position, Global.node_creation_parent)
				bullet_particles_instance.rotation = velocity.angle()
				bullet_particles_instance.get_node("Particles2D").emitting = true
			
			
		if area.is_in_group("EnemyDestroyer") and stun == false:
			
#			var bazookaRadius = area.get_node("CollisionShape2D2").shape.radius
			
			modulate = Color("ff0000")
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
		elif area.is_in_group("EnemyDestroyerM") and stun == false:
			modulate = Color.white
			if hp > 2:
				velocity = -velocity * 10
				stun = true
			elif hp <= 2:
				velocity = -velocity * 5
				stun = true
				stunTimer = false
			hp -= 2
			if stunTimer == true:
				$StunTimer.start()
	
	pass


func _on_StunTimer_timeout():
	
	modulate = Color("ffffff")
	stun = false
	got_hit = false
	can_look = true
	
	pass


func _on_DeathTimer_timeout():
	
	emit_signal("enemy_dead")
	queue_free()
	print("EnemyDead")
	#you should use an animation finish to queue_free but we're gonna use this one 4 now
	
	pass

func screen_shake():
	
	emit_signal("expo_dead")
	emit_signal("enemy_dead")
	var poof_instance = Global.instance_node(poof, global_position, Global.node_creation_parent)
	poof_instance.get_node("Particles2D").emitting = true
	
	pass

func explode1():
	
	$Explode1.play()
	
	pass

func explode2():
	
	$Exploade2.play()
	
	pass

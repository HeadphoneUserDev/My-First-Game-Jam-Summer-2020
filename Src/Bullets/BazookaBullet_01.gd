extends Sprite

var belocity = Vector2()
var velocity = Vector2(1, 0)
var speed = 10
var max_speed = 1000
var stop = 0

var exploded = false

var look_once = true
var used = false

var explosion_particles = preload("res://Src/ParticleEffects/Explosion.tscn")
var bazookaLaunchingparticles = preload("res://Src/ParticleEffects/BazookaLaunchingParticles.tscn")
var bazooka_boost = preload("res://Src/ParticleEffects/BazookaBoost.tscn")

onready var animPlayer = $ButtPosition/AnimationPlayer

func _ready():
	
	animPlayer.play("Launching")
	
	
	pass

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
	
	if body.is_in_group("Enemy") and body.dead == false:
		if exploded == false:
			$AnimationPlayer.play("BazookaExplosion")
			velocity = Vector2.ZERO
	#		speed = lerp(speed, stop, 1)
			exploded = true
			$DetectHitBox.queue_free()
		
		if Global.node_creation_parent != null:
			var explosion_particles_intance = Global.instance_node(explosion_particles, global_position, Global.node_creation_parent)
			explosion_particles_intance.rotation = velocity.angle()
			explosion_particles_intance.get_node("Particles2D").emitting = true
			explosion_particles_intance.get_node("Particles2D2").emitting = true
	
	
	pass

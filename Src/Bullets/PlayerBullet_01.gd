extends Sprite

var velocity = Vector2(1, 0)
var speed = 450
var movement_vector = Vector2(1, 0)

var some_vector = Vector2.DOWN

var look_once = true

var bullet_particles = preload("res://Src/ParticleEffects/PistolPoof.tscn")

onready var hitBox = $Hitbox
onready var trail = $Line2D

func _ready():
	
	hitBox.knockback_vector = some_vector
	
	pass

func _process(delta):
	
	var move_vector = velocity
	
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	
	global_position += velocity.rotated(rotation) * speed * delta
	
	hitBox.knockback_vector = move_vector
	
	pass

func _on_VisibilityNotifier2D_screen_exited():
	
	queue_free()
	
	pass

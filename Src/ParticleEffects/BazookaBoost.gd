extends Node2D

onready var animPlayer = $AnimationPlayer
onready var worldEnvironment = $WorldEnvironment

func _ready():
	
	animPlayer.play("Launching")
	
	pass

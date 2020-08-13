extends CanvasLayer

var bar_red = preload("res://MFGJ Sprites/HealthBar/HealthRedColor.png")
var bar_yellow = preload("res://MFGJ Sprites/HealthBar/HealthYellowColor.png")
var bar_orange = preload("res://MFGJ Sprites/HealthBar/HealthOrangeColor.png")
var bar_green = preload("res://MFGJ Sprites/HealthBar/HealthGreenColor.png")
var bar_texture

var connected = false

onready var anim = $AnimationPlayer

func _ready():
	
#	anim.play("healthBar_flash")
	
	pass

func update_healthbar(value):
	
	bar_texture = bar_green
	if value < 65:
		bar_texture = bar_yellow
	if value < 45:
		bar_texture = bar_orange
	if value < 25:
		bar_texture = bar_red
	
	$AnimationPlayer2.play("healthbar_flash")
	$HealthBar.texture_progress = bar_texture
	$HealthBar/Tween.interpolate_property($HealthBar, 'value', $HealthBar.value, value, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$HealthBar/Tween.start()
	
#	$HealthBar.value = value
	
	pass

func weapon_change(value):
	
	$WeaponDisplay/Pistol.visible = false
	$WeaponDisplay/MachineGun.visible = false
	$WeaponDisplay/Bazooka.visible = false
	$WeaponDisplay/WarpDevice.visible = false
	
	if value == 1:
		$AnimationPlayer.play("pistol_appear")
	elif value == 2:
		$AnimationPlayer.play("machinegun_appear")
	elif value == 3:
		$AnimationPlayer.play("bazooka_appear")
	elif value == 4:
		$AnimationPlayer.play("warpdevice_appear")
	else:
		$AnimationPlayer.stop()
	
	pass


func _on_AnimationPlayer2_animation_finished(anim_name):
	
	if anim_name == 'healthbar_flash':
		$HealthBar.texture_progress = bar_texture
	
	pass 

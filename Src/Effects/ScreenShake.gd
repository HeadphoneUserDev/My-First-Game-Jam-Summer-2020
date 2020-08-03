extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

onready var camera = get_parent()

func start(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	#This method will be called from outside of the script whenever you want to initiate a screen shake
	#It's going to need four parameters
	if priority >= self.priority:
		self.priority = priority
		self.amplitude = amplitude
		
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		$Duration.start()
		$Frequency.start()
		
		_new_shake() 
	
	pass

func _new_shake():
	
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	#I don't know where the "Offset" came from
	$ShakeTween.start()
	
	pass

func reset():
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, $Frequency.wait_time, TRANS, EASE)
	#I don't know where the "Offset" came from
	priority = 0
	
	pass

func _on_Frequency_timeout():
	
	_new_shake()
	
	pass


func _on_Duration_timeout():
	
	reset()
	$Frequency.stop()
	
	pass

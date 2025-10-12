extends ColorRect

func _input(_event):
	# quit when Esc is pressed
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	

# target beats per minute (to dance to)
const target_bpm : float = 140

# "seconds per beat" 
const spb : float = 60 / target_bpm

# position (translation of 
var p = Vector2(0, -0.75)

# time when the animation started
var start : float = Time.get_unix_time_from_system()

func _process(_delta):
	var now = Time.get_unix_time_from_system()
	
	# time in seconds since the animation started
	var t = now - start
	
	# "current angle in the beat/bar" (goes from zero when the beat starts, to 2π when the next beat starts)
	var theta = 2 * PI * t / spb
	
	# circular functions varying in time with the beat
	var f1 = 0.7 * sin(theta / 4)
	var f2 = 1.3 * sin(theta / 16)
	var f3 = sin(theta / 7)
	var f4 = 3 * sin(theta / 96)
	
	# vary zoom level
	var zoom = 0.2 * (f1 + f2 + f3 + f4) / 2 + sin(t) / 8
	
	# vary translation (centre position)
	p.x = 0.5 * sin(theta / 101) * sin(theta / 103)
	p.y = -0.75 + 0.5 * sin(theta / 101) * sin(theta / 104) + sin(theta) / 32
	
	# vary the value of "²" in "z ↦ z²+c"
	var tiq = 2.0 + tan(theta / 64)
	
	# 💗 stayin' alive
	tiq = 4.5 + f1 + tan(f4)
	
	# update shader params
	$".".material.set("shader_parameter/position", p)
	$".".material.set("shader_parameter/zoom", zoom)
	$".".material.set("shader_parameter/tiq", tiq)

	#print('"2" = ', tiq)
	

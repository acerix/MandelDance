extends ColorRect

func _input(_event):
	# quit when pressing Esc
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	

var bpm : float = 140
var beat_factor : float = 60 / bpm
var start : float = Time.get_unix_time_from_system()
var p = Vector2(0, -0.75);

func _process(_delta):
	var time = Time.get_unix_time_from_system()
	var delta = time - start
	var theta = 2 * PI * delta / beat_factor
	var f1 = 0.7 * sin(theta / 4)
	var f3 = sin(theta / 7)
	var f2 = 1.3 * sin(theta / 16)
	var f4 = 3 * sin(theta / 96)
	var zoom = 0.2 * f1 * f2 * f3 * f4 + sin(delta) / 8
	p.x = 0.5 * sin(theta / 101) * sin(theta / 103)
	p.y = -0.75 + 0.5 * sin(theta / 101) * sin(theta / 104) + sin(theta) / 32
	var tiq = 2.0 + tan(theta / 64)
	$".".material.set("shader_parameter/position", p)
	$".".material.set("shader_parameter/zoom", zoom)
	$".".material.set("shader_parameter/tiq", tiq)

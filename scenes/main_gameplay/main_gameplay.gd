extends Node3D


const WAVEGOAL = 15
const SPAWN_CIRLCE_DIST = 40
const VILLAGE_ORIGIN = Vector3(16, 0, 16)

var events = 0
var wave_strength = 8

var goblin_scene = preload("res://actors/units/goblin/goblin.tscn")

func _on_event_timer_timeout() -> void:
	events += 1
	if events >= WAVEGOAL:
		SceneGirl.change_scene("res://scenes/win/win.tscn")
	
	if events % 2 == 0:
		pass
		#encampment
	else:
		for i in wave_strength:
			spawn_unit(i)
		wave_strength += 2

func spawn_unit(current: int):
	var new_goblin = goblin_scene.instantiate()
	var angle = float(current) / float(wave_strength) * PI * 2.0
	new_goblin.position = Vector3(cos(angle) * SPAWN_CIRLCE_DIST, 0, sin(angle) * SPAWN_CIRLCE_DIST) + VILLAGE_ORIGIN
	add_child(new_goblin)

extends Node3D


const WAVEGOAL = 8
const RESCUE_GOAL = 5
const SPAWN_CIRLCE_DIST = 40
const VILLAGE_ORIGIN = Vector3(16, 0, 16)

var events = 0
var wave_strength = 2

var goblin_scene = preload("res://actors/units/goblin/goblin.tscn")
var encampment_scene = preload("res://actors/encampments/goblin_camp/goblin_camp.tscn")


@onready var encampment_spawns = $EncampmentSpawns
@onready var wave_timer_label = $UI/Label
@onready var event_timer: Timer = $EventTimer

func _ready() -> void:
	for spawn in encampment_spawns.get_children():
		var encampment = encampment_scene.instantiate()
		encampment.position = spawn.position
		add_child(encampment)
	
	Messages.freeze_game.connect(func (f):
		event_timer.paused = f
	)

func _process(_delta: float) -> void:
	wave_timer_label.text = "Time till next wave: " + str(int(event_timer.time_left))
	if Globals.caplings_rescued > RESCUE_GOAL:
		SceneGirl.change_scene("res://scenes/win/win.tscn")

func _on_event_timer_timeout() -> void:
	events += 1
	if events >= WAVEGOAL:
		SceneGirl.change_scene("res://scenes/win/win.tscn")
	
	for i in wave_strength:
		spawn_unit(i)
	wave_strength += 2

func spawn_unit(current: int):
	var new_goblin = goblin_scene.instantiate()
	var angle = float(current) / float(wave_strength) * PI * 2.0
	new_goblin.position = Vector3(cos(angle) * SPAWN_CIRLCE_DIST, 0, sin(angle) * SPAWN_CIRLCE_DIST) + VILLAGE_ORIGIN
	add_child(new_goblin)
	new_goblin.origin_position = Vector3(16, 0, 16)
	new_goblin.max_distance_from_origin = 5

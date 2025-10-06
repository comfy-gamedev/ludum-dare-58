extends Node2D

var ally_scene = preload("res://actors/units/capling/capling.tscn")
const VILLAGE_ORIGIN = Vector3(-16, 0, 16)
var allies = []
var jump_impulses = []
var time = 0.0
#var jump_impulse = 0

func _ready() -> void:
	for i in 20:
		var ally: base_unit = ally_scene.instantiate()
		ally.position = Vector3(randf_range(-10, 10), 0, randf_range(-10, 10))
		var hat = Globals.hat_scene_pool[Globals.hat_scene_pool.keys().pick_random()].instantiate()
		hat.position = Vector3(0, 2, 0)
		hat.process_mode = Node.PROCESS_MODE_DISABLED
		ally.add_child(hat)
		add_child(ally)
		allies.append(ally)
		jump_impulses.append(randf())

func _physics_process(delta: float) -> void:
	time += delta
	var ally
	for i in allies.size():
		ally = allies[i]
		jump_impulses[i] -= delta * 1.1
		ally.position += Vector3.UP * jump_impulses[i] * 0.2
		if ally.position.y <= 0:
			jump_impulses[i] = 1.0
		#ally.position += Vector3.UP * abs(sin(time)) * 1

func _on_button_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_menu/main_menu.tscn")


func _on_button_2_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_gameplay/main_gameplay.tscn")

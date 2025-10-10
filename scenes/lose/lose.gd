extends Node2D

var goblin_scene = preload("res://actors/units/goblin/goblin.tscn")
const VILLAGE_ORIGIN = Vector3(-16, 0, 16)
var allies = []
var jump_impulses = []

func _ready() -> void:
	for i in 20:
		var goblin: base_unit = goblin_scene.instantiate()
		goblin.position = Vector3(randf_range(-10, 10), 0, randf_range(-10, 10))
		add_child(goblin)
		allies.append(goblin)
		jump_impulses.append(randf())

func _physics_process(delta: float) -> void:
	var goblin
	for i in allies.size():
		goblin = allies[i]
		jump_impulses[i] -= delta * 1.1
		goblin.position += Vector3.UP * jump_impulses[i] * 0.2
		if goblin.position.y <= 0:
			jump_impulses[i] = 1.0

func _on_button_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_menu/main_menu.tscn")
	Globals.reset()


func _on_button_2_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_gameplay/main_gameplay.tscn")
	Globals.reset()

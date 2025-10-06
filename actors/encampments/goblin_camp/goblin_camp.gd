extends Node3D
var goblin_scene = preload("res://actors/units/goblin/goblin.tscn")

@export var number_of_enemies = 3

func _ready() -> void:
	spawn_enemies.call_deferred()

func spawn_enemies():
	for i in number_of_enemies:
		var new_goblin = goblin_scene.instantiate()
		var goblin_pos = Vector3(self.global_position.x + randf_range(-5, 5), 0, self.global_position.z + randf_range(-5, 5))
		new_goblin.global_position = goblin_pos
		$/root/MainGameplay.add_child(new_goblin)

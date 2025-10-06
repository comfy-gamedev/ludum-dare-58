extends base_camp
var capling_scene = preload("uid://dfvu7kkdxffly")

var starting_number_of_caplings = 3
var has_been_called = false

func _ready() -> void:
	spawn_starting_units.call_deferred()

func on_encampment_destroyed():
	if not has_been_called:
		has_been_called = true
		print("ALL CAPLINGS DEAD! GAME OVER!")
		SceneGirl.change_scene("res://scenes/lose/lose.tscn")

func spawn_starting_units():
	for i in starting_number_of_caplings:
		spawn_unit()

func spawn_unit():
	current_number_of_units += 1
	var new_capling = capling_scene.instantiate()
	var capling_pos = Vector3(self.global_position.x + randf_range(-5, 5), 0, self.global_position.z + randf_range(-5, 5))
	new_capling.global_position = capling_pos
	new_capling.encampment_ref = self
	$/root/MainGameplay.add_child(new_capling)

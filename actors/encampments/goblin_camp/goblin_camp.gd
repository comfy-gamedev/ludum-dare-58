extends base_camp
var goblin_scene = preload("uid://cwajxjg83lhvk")

@export var number_of_units = 3
var has_been_called = false

func _ready() -> void:
	spawn_units.call_deferred()
	current_number_of_units = number_of_units

func on_encampment_destroyed():
	if not has_been_called:
		has_been_called = true
		print("capling freed!")
		# Spawn freed capling in home camp.
		$/root/MainGameplay/HomeCamp.spawn_unit()
		# Remove cage model.
		$Cage.queue_free()
		# TODO: Cool little animation of freed capling jumping for joy.
		await get_tree().create_timer(2.0).timeout
		# Remove enemy camp.
		self.queue_free()

func spawn_units():
	for i in number_of_units:
		spawn_unit()

func spawn_unit():
	var new_goblin = goblin_scene.instantiate()
	var goblin_pos = Vector3(self.global_position.x + randf_range(-5, 5), 0, self.global_position.z + randf_range(-5, 5))
	new_goblin.global_position = goblin_pos
	new_goblin.encampment_ref = self
	$/root/MainGameplay.add_child(new_goblin)

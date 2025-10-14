extends base_camp
var goblin_scene = preload("uid://cwajxjg83lhvk")

@export var number_of_units = 3
@onready var caged_capling = $CagedCapling

var jump_impulse = 0.5
var has_spawned = false
var capling_freed = false

func _physics_process(delta: float) -> void:
	if capling_freed:
		# Process capling jumping for joy.
		jump_impulse -= delta * 1.1
		caged_capling.position += Vector3.UP * jump_impulse * 0.2
		if caged_capling.position.y <= 0:
			jump_impulse = 0.5

func on_encampment_destroyed():
	if not capling_freed:
		capling_freed = true
		print("capling freed!")
		# Spawn freed capling in home camp.
		$/root/MainGameplay/HomeCamp.spawn_unit()
		# Remove cage model.
		$Cage.queue_free()
		#$lilbuddy.AnimationPlayer.play("yipee")
		await get_tree().create_timer(2.7).timeout
		Globals.caplings_rescued += 1
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

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("ally") && !has_spawned:
		spawn_units()
		current_number_of_units = number_of_units
		has_spawned = true

extends base_enemy

@onready var target_seeking_radius: Area3D = $TargetSeekingRadius

var hat_drop_scene = preload("res://actors/hats/icicle/icicle_hat.tscn")

func _init() -> void:
	health = 3
	damage = 1
	speed = 3.0
	accel = 3.0
	attack_acceptance_range = 5


func get_closest_detected_target() -> Node3D:
	var bodies = target_seeking_radius.get_overlapping_bodies().filter(func (x): return x.is_in_group("ally"))
	
	if bodies.is_empty():
		return null
	
	bodies.sort_custom(func (a, b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	return bodies[0]

func on_hit(_damage: int):
	health -= _damage
	
	if health <= 0:
		on_death()

func on_death():
	spawn_hat_drop()
	self.queue_free()

func spawn_hat_drop():
	var new_hat_drop = hat_drop_scene.instantiate()
	var hat_drop_pos = Vector3(self.global_position.x, 0, self.global_position.z)
	new_hat_drop.set_position(hat_drop_pos)
	self.get_parent().add_child(new_hat_drop)

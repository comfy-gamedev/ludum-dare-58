extends base_unit

@onready var target_seeking_radius: Area3D = $TargetSeekingRadius

func _init() -> void:
	health = 3
	damage = 1
	speed = 3.0
	accel = 3.0
	attack_acceptance_range = 5
	#hat = init_hat()

func get_closest_detected_target() -> Node3D:
	if not is_instance_valid(equipped_hat):
		return null
	
	var bodies = target_seeking_radius.get_overlapping_bodies().filter(func (x): return x.is_in_group("enemy"))
	
	if bodies.is_empty():
		return null
	
	bodies.sort_custom(func (a, b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	return bodies[0]

func trigger_hat_skill(dir: Vector3, bullet_parent: Node3D):
	if is_instance_valid(equipped_hat):
		equipped_hat.fire(dir, bullet_parent)

func on_hit(_damage: int):
	health -= _damage
	
	if health <= 0:
		on_death()

func on_death():
	if is_instance_valid(equipped_hat):
		drop_hat()
	
	self.queue_free()

func drop_hat():
	equipped_hat.linear_velocity = Vector3(randf() - 2.5, 0, randf() - 0.5).normalized() * 5
	equipped_hat.process_mode = Node.PROCESS_MODE_INHERIT
	equipped_hat.pickup_ready = false
	equipped_hat.reparent(get_parent())
	equipped_hat = null

func equip_hat(new_hat: Node3D):
	var hat_pos = Vector3(self.global_position.x, 2.5, self.global_position.z)
	new_hat.team = Globals.teams.ALLY
	new_hat.set_position(hat_pos)
	new_hat.process_mode = Node.PROCESS_MODE_DISABLED
	new_hat.reparent(self)
	equipped_hat = new_hat

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("hat") and is_instance_valid(equipped_hat):
		drop_hat()
		
	if body.is_in_group("hat"):
		equip_hat(body)

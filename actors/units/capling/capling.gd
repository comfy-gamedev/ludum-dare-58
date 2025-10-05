extends base_unit

@onready var target_seeking_radius: Area3D = $TargetSeekingRadius

func _init() -> void:
	health = 3
	damage = 1
	speed = 3.0
	accel = 3.0
	attack_acceptance_range = 5
	#hat = init_hat()

func on_hit(_damage: int):
	pass

func get_closest_detected_target() -> Node3D:
	#if is_instance_valid(equipped_hat):
		#return null
	return null # TODO: implement

func trigger_hat_skill(_dir: Vector3, _bullet_parent: Node3D):
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("hat") and is_instance_valid(equipped_hat):
		drop_hat()
		
	if body.is_in_group("hat"):
		equip_hat(body)

func drop_hat():
	equipped_hat.reparent(get_parent())
	equipped_hat.linear_velocity = Vector3(randf() - 0.5, 0, randf() - 0.5).normalized() * 5
	equipped_hat.process_mode = Node.PROCESS_MODE_INHERIT
	equipped_hat.pickup_ready = false
	equipped_hat = null

func equip_hat(new_hat: Node3D):
	var hat_pos = Vector3(self.global_position.x, 2.5, self.global_position.z)
	new_hat.team = Globals.teams.ALLY
	new_hat.set_position(hat_pos)
	new_hat.process_mode = Node.PROCESS_MODE_DISABLED
	new_hat.reparent(self)
	equipped_hat = new_hat

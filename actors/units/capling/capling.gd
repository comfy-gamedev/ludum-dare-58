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
	if is_instance_valid(hat):
		return null
	return null # TODO: implement

func trigger_hat_skill(_dir: Vector3, _bullet_parent: Node3D):
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("hat") && not is_instance_valid(hat):
		equip_hat(body)

func equip_hat(new_hat: Node3D):
	var hat_pos = Vector3(self.global_position.x, 2.5, self.global_position.z)
	new_hat.team = Globals.teams.ALLY
	new_hat.set_position(hat_pos)
	new_hat.process_mode = Node.PROCESS_MODE_DISABLED
	new_hat.reparent(self)
	hat = new_hat

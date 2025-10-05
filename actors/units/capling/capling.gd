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
	return null

func trigger_hat_skill(_dir: Vector3, _bullet_parent: Node3D):
	pass

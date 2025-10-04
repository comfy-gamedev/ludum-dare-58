class_name Hat extends RigidBody3D

@onready var cooldown = $PickupCooldown

var team = 0
var pickup_ready: bool:
	get:
		return cooldown.is_stopped()
	set(x):
		cooldown.start()

func _init() -> void:
	linear_velocity = Vector3(5, 0, 5)

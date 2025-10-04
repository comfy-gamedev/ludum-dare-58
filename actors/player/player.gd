extends CharacterBody3D


const SPEED = 5.0
const ACCEL = 5.0

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity = velocity.move_toward(direction * SPEED, ACCEL * 5.0)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, ACCEL * 5.0)
	
	move_and_slide()

extends CharacterBody3D


const SPEED = 5.0
const ACCEL = 5.0

var bullet_scene = preload("res://actors/bullets/Bullet.tscn")

@onready var targeting_ball = $TargetingBall
@onready var raycast : RayCast3D = $Camera3D/RayCast3D
@onready var camera = $Camera3D
@onready var bullet_parent = $"../BulletParent"
@onready var cooldown = $Cooldown

func _process(delta: float) -> void:
	var cursor_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(cursor_position)
	var ray_direction = camera.project_local_ray_normal(cursor_position)
	
	raycast.target_position = ray_origin + ray_direction * 1000
	#raycast.force_raycast_update()
	targeting_ball.global_position = raycast.get_collision_point()
	
	if Input.is_action_just_pressed("shoot") && cooldown.is_stopped():
		cooldown.start()
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		bullet.direction = Vector3(targeting_ball.position.x, 0, targeting_ball.position.z).normalized()
		bullet_parent.add_child(bullet)

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

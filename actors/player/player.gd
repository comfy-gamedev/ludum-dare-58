extends CharacterBody3D


const SPEED = 5.0
const ACCEL = 5.0
var hats: Array[Hat] = []

var bullet_scene = preload("res://actors/bullets/bullet.tscn")

@onready var targeting_ball = $TargetingBall
@onready var camera = $Camera3D
@onready var bullet_parent = $"../BulletParent"
@onready var cooldown = $Cooldown
@onready var hat_parent = $HatParent

func _process(delta: float) -> void:
	var cursor_position = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(cursor_position)
	var ray_direction = camera.project_ray_normal(cursor_position)
	var ground_plane = Plane(Vector3.UP, Vector3.ZERO)
	
	var temp_pos = ground_plane.intersects_ray(ray_origin, ray_direction)
	targeting_ball.global_position = temp_pos if temp_pos != null else Vector3.ZERO
	
	if Input.is_action_pressed("shoot") && cooldown.is_stopped():
		cooldown.start()
		if hats.size() > 0:
			hats[0].fire(Vector3(targeting_ball.position.x, 0, targeting_ball.position.z).normalized(), bullet_parent)
		else:
			var bullet = bullet_scene.instantiate()
			bullet.position = position + Vector3.UP
			bullet.direction = Vector3(targeting_ball.position.x, 0, targeting_ball.position.z).normalized()
			bullet_parent.add_child(bullet)
	
	if Input.is_action_just_pressed("eject") && hats.size() > 0:
		var hat = hats.pop_back()
		hat.reparent(get_parent())
		hat.linear_velocity = Vector3(targeting_ball.position.x, 0, targeting_ball.position.z).normalized() * 5
		hat.process_mode = Node.PROCESS_MODE_INHERIT
		hat.pickup_ready = false
	

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity = velocity.move_toward(direction * SPEED, ACCEL * 5.0)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, ACCEL * 5.0)
	
	if Input.is_key_pressed(KEY_SHIFT):
		velocity *= 10.0
	move_and_slide()
	if Input.is_key_pressed(KEY_SHIFT):
		velocity /= 10.0



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("hat") && body.pickup_ready && hats.find(body) == -1:
		hats.append(body)
		body.reparent(hat_parent)
		body.position = Vector3(0, .75 * hats.size(), 0)
		body.process_mode = Node.PROCESS_MODE_DISABLED
		#body.linear_velocity = Vector3.ZERO
		if hats.size() == 1:
			cooldown.wait_time = body.use_cooldown

func _on_hit():
	if hats.size() > 0:
		for hat in hats:
			hat.reparent(get_parent())
			hat.linear_velocity = Vector3(randf() - 0.5, 0, randf() - 0.5).normalized() * 5
			hat.process_mode = Node.PROCESS_MODE_INHERIT
			hat.pickup_ready = false
	else:
		#death
		pass

extends CharacterBody3D

const ACCEL = 5.0
const SPEED_START = 10.0
var speed = SPEED_START
var hats: Array[Hat] = []

var bullet_scene = preload("res://actors/bullets/bullet.tscn")

@onready var targeting_ball = $TargetingBall
@onready var camera = $Camera3D
@onready var bullet_parent = $"../BulletParent"
@onready var cooldown = $Cooldown
@onready var hat_parent = $HatParent
@onready var effect_timer = $EffectTimer
@onready var dash_cooldown = $DashCooldown
@onready var model: Node3D = $Model
@onready var animation_tree: AnimationTree = $Model/AnimationTree
@onready var compass = $CompassGimbal/Compass
@onready var compass_gimbal: Node3D = $CompassGimbal

func _ready() -> void:
	Messages.freeze_game.connect(func (f):
		cooldown.paused = f
		effect_timer.paused = f
		dash_cooldown.paused = f
	)

func _process(delta: float) -> void:
	if Messages.frozen:
		return
	
	var compass_angle = (Vector3(16, position.y, 16) - position).normalized()
	compass_gimbal.basis = Basis.looking_at(compass_angle, Vector3.UP, true)
	
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
			bullet.team = Globals.teams.ALLY
			bullet.position = position + Vector3.UP
			bullet.direction = Vector3(targeting_ball.position.x, 0, targeting_ball.position.z).normalized()
			bullet_parent.add_child(bullet)
		animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		MusicMan.sfx(preload("res://assets/sfx/shoot.wav"))
	
	if Input.is_action_just_pressed("eject") && hats.size() > 0:
		eject_hat()
	
	animation_tree["parameters/IdleRun/blend_position"] = velocity.length() / speed
	
	if velocity:
		model.rotation.y = -velocity.signed_angle_to(Vector3.MODEL_FRONT, Vector3.UP)

func eject_hat():
	var hat = hats.pop_back()
	hat.reparent(get_parent())
	hat.linear_velocity = Vector3(targeting_ball.position.x, 0, targeting_ball.position.z).normalized() * 5
	hat.process_mode = Node.PROCESS_MODE_INHERIT
	hat.pickup_ready = false
	
	if hats.size() < 1:
		cooldown.wait_time = 1.0

func _physics_process(delta: float) -> void:
	if Messages.frozen:
		return
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_dir.y, 0, -input_dir.x).normalized()
	var gravity := Vector3(0, -50.0, 0) * delta
	var target_speed := Vector3(direction.x * speed, velocity.y, direction.z * speed) + gravity
	velocity = velocity.move_toward(target_speed, ACCEL * 5.0)
	
	if Input.is_key_pressed(KEY_0):
		velocity *= Vector3(10.0, 1.0, 10.0)
	if Input.is_action_just_pressed("dodge") && dash_cooldown.is_stopped():
		speed *= 4.0
		dash_cooldown.start()
	move_and_slide()
	if Input.is_key_pressed(KEY_0):
		velocity /= Vector3(10.0, 1.0, 10.0)
	if speed > SPEED_START:
		speed -= delta * SPEED_START * 8.5



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("hat") && body.pickup_ready && hats.find(body) == -1:
		hats.append(body)
		body.reparent(hat_parent)
		body.position = Vector3(0, (.75 * hats.size()) - .25, 0)
		body.process_mode = Node.PROCESS_MODE_DISABLED
		#body.linear_velocity = Vector3.ZERO
		if hats.size() == 1:
			cooldown.wait_time = body.use_cooldown
			
func on_hit(damage = 1, slowing = false):
	_on_hit(damage, slowing)

func _on_hit(_damage, slowing):
	# Drop hats if carrying.
	if hats.size() > 0:
		for hat in hats:
			hat.reparent(get_parent())
			hat.linear_velocity = Vector3(randf() - 0.5, 0, randf() - 0.5).normalized() * 5
			hat.process_mode = Node.PROCESS_MODE_INHERIT
			hat.pickup_ready = false
		
		cooldown.wait_time = 1.0
		hats = []
		if slowing:
			speed /= 2
			effect_timer.start()
		MusicMan.sfx(preload("res://assets/sfx/playerdamage.wav"))
	else:
		on_death()

func on_death():
	MusicMan.sfx(preload("res://assets/sfx/playerdeath.wav"))
	# Respawn player at home camp.
	position = Vector3(16, 0, 16)

func _on_effect_timer_timeout() -> void:
	speed = SPEED_START

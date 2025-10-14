extends base_unit

@onready var target_seeking_radius: Area3D = $TargetSeekingRadius
@onready var effect_timer = $EffectTimer
@onready var actor_tree: BeehaveTree = $ActorTree
@onready var animation_tree: AnimationTree = $lilbuddy/AnimationTree

func _init() -> void:
	health = 10
	damage = 1
	speed = 3.0
	accel = 3.0
	attack_acceptance_range = 7.5
	max_distance_from_origin = 10

func _ready() -> void:
	origin_position = Vector3(self.global_position)
	Messages.freeze_game.connect(func (f):
		effect_timer.paused = f
		if f:
			actor_tree.disable()
		else:
			actor_tree.enable()
	)

func _physics_process(_delta: float) -> void:
	animation_tree["parameters/IdleRun/blend_position"] = velocity.length() / speed
	move_and_slide()

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
		animation_tree["parameters/AttackOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func on_hit(_damage: int, _type: Globals.elements, slowing = false):
	health -= _damage
	
	if slowing:
		speed /= 2
		effect_timer.start()
	
	if health <= 0:
		MusicMan.sfx(preload("res://assets/sfx/friendlydeath.wav"))
		on_death()

func on_death():
	if is_instance_valid(equipped_hat):
		drop_hat()
	
	if is_instance_valid(encampment_ref):
		process_encampment_updates()
	
	self.queue_free()

func process_encampment_updates():
	# Reduce home encampment capling counter by one.
	encampment_ref.current_number_of_units -= 1
	
	# Trigger encampment destroyed method.
	if encampment_ref.current_number_of_units <= 0:
		encampment_ref.on_encampment_destroyed()

func drop_hat():
	equipped_hat.linear_velocity = Vector3(randf() - 2.5, 0, randf() - 0.5).normalized() * 5
	equipped_hat.process_mode = Node.PROCESS_MODE_INHERIT
	equipped_hat.pickup_ready = false
	equipped_hat.reparent(get_parent())
	equipped_hat = null

func equip_hat(new_hat: Node3D):
	var hat_pos = Vector3(self.global_position.x, 1.5, self.global_position.z)
	new_hat.team = Globals.teams.ALLY
	new_hat.set_position(hat_pos)
	new_hat.process_mode = Node.PROCESS_MODE_DISABLED
	new_hat.reparent(self)
	equipped_hat = new_hat

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("hat") && body.pickup_ready:
		if is_instance_valid(equipped_hat):
			drop_hat()
		equip_hat(body)
	


func _on_effect_timer_timeout() -> void:
	speed = 3.0

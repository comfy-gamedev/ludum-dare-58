extends base_unit

@onready var target_seeking_radius: Area3D = $TargetSeekingRadius
@onready var effect_timer = $EffectTimer

# TODO: This will eventually pull from a random pool of hats.
var hat_scene

func _init() -> void:
	health = 3
	damage = 1
	speed = 3.0
	accel = 3.0
	attack_acceptance_range = 5
	max_distance_from_origin = 25 #50
	equipped_hat = init_hat()

func _ready() -> void:
	origin_position = Vector3(self.global_position)

func choose_random_hat_scene() -> PackedScene:
	var hat_keys_array = Globals.hat_scene_pool.keys()
	var random_index = randi_range(0, hat_keys_array.size() - 1)
	var random_hat_key = hat_keys_array[random_index]
	return Globals.hat_scene_pool[random_hat_key]

func trigger_hat_skill(dir: Vector3, bullet_parent: Node3D):
	if is_instance_valid(equipped_hat):
		equipped_hat.fire(dir, bullet_parent)
		#add animation here

func init_hat() -> Hat:
	hat_scene = choose_random_hat_scene()
	var enemy_hat = hat_scene.instantiate()
	#enemy_hat.element = Globals.elements.values().pick_random()
	enemy_hat.team = Globals.teams.ENEMY
	var init_hat_pos = Vector3(0, 2.5, 0)
	enemy_hat.set_position(init_hat_pos)
	enemy_hat.process_mode = Node.PROCESS_MODE_DISABLED
	self.add_child(enemy_hat)
	return enemy_hat

func get_closest_detected_target() -> Node3D:
	var bodies = target_seeking_radius.get_overlapping_bodies().filter(func (x): return x.is_in_group("ally"))
	
	if bodies.is_empty():
		return null
	
	bodies.sort_custom(func (a, b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	return bodies[0]

func on_hit(_damage: int, type: Globals.elements , slowing = false):
	if ((equipped_hat.element == Globals.elements.FIRE && type == Globals.elements.WATER) ||
		(equipped_hat.element == Globals.elements.AIR && type == Globals.elements.FIRE) ||
		(equipped_hat.element == Globals.elements.EARTH && type == Globals.elements.AIR) ||
		(equipped_hat.element == Globals.elements.WATER && type == Globals.elements.EARTH)):
		_damage *= 2
	
	health -= _damage
	
	if slowing:
		speed /= 2
		effect_timer.start()
	
	if health <= 0:
		on_death()

func on_death():
	spawn_hat_drop()
	
	if is_instance_valid(encampment_ref):
		process_encampment_updates()
	
	self.queue_free()

func process_encampment_updates():
	# Reduce encampment enemy counter by one.
	encampment_ref.current_number_of_units -= 1
	
	# Trigger encampment destroyed method.
	if encampment_ref.current_number_of_units <= 0:
		encampment_ref.on_encampment_destroyed()

func spawn_hat_drop():
	var new_hat_drop = hat_scene.instantiate()
	var hat_drop_pos = Vector3(self.global_position.x, 0, self.global_position.z)
	new_hat_drop.global_position = hat_drop_pos
	#get_tree().get_root().add_child(new_hat_drop)
	self.get_parent().add_child(new_hat_drop)


func _on_effect_timer_timeout() -> void:
	speed = 3.0

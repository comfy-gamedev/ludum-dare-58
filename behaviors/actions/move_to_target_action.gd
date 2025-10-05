class_name MoveToTargetAction
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	if not is_instance_valid(target):
		return FAILURE
	
	var target_pos = target.global_position
	
	var distance_to_target = actor.position.distance_to(target_pos)
	
	if distance_to_target <= actor.attack_acceptance_range:
		return SUCCESS
	
	#var direction: Vector2 = (target_pos - actor.position).normalized()
	#
	## Otherwise, move towards the target
	#actor.velocity = actor.movement_speed * direction
	#
	#if actor.move_and_slide():
		#var collider = actor.get_last_slide_collision().get_collider()
		#if collider is Unit or collider is Building:
			#blackboard.set_value("target", collider)
			#blackboard.set_value("target_locked", true)
			
	# Calculate the direction to the target position
	var target_pos_vec2 = Vector2(target_pos.x, target_pos.z)
	var actor_pos_vec2 = Vector2(actor.position.x, actor.position.z)
	var direction = Vector3(target_pos_vec2.x - actor_pos_vec2.x, 0, target_pos_vec2.y - actor_pos_vec2.y).normalized()
	
	var current_distance_to_target = actor_pos_vec2.distance_to(target_pos_vec2)
	
	if current_distance_to_target > distance_to_target/2:
		actor.velocity = actor.velocity.move_toward(direction * actor.speed, actor.accel * 5.0)
	
	distance_to_target = actor.position.distance_to(target_pos)
	
	# If the distance to the target is less than the step, set the final position.
	if distance_to_target <= actor.attack_acceptance_range:
		return SUCCESS
	else:
		actor.move_and_slide()
		return RUNNING

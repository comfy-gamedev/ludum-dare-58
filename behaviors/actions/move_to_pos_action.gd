class_name MoveToPosAction
extends ActionLeaf

@export var acceptance_radius = 5

const SPEED = 3.0
const ACCEL = 3.0

# This action moves the actor towards a given target pos (new_pos in Blackboard).
# Note: This action should always be the child of a TimeLimiterDecorator in the event 
# that the actor is unable to meet the acceptance_radius.
func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_pos = blackboard.get_value("new_pos")
	var distance_to_target = blackboard.get_value("distance_to_target")
	var delta = get_physics_process_delta_time()
	
	# Calculate the direction to the target position
	var target_pos_vec2 = Vector2(target_pos.x, target_pos.z)
	var actor_pos_vec2 = Vector2(actor.position.x, actor.position.z)
	var direction = Vector3(target_pos_vec2.x - actor_pos_vec2.x, 0, target_pos_vec2.y - actor_pos_vec2.y).normalized()
	var current_distance_to_target = actor_pos_vec2.distance_to(target_pos_vec2)
	
	# Flip sprite if it exists.
	#var spriteNode = actor.get_node_or_null("AnimatedSprite2D")
	#if spriteNode:
		#if direction.x > 0:
			#spriteNode.flip_h = true
		#else:
			#spriteNode.flip_h = false
	
	#if direction:
		#velocity = velocity.move_toward(direction * SPEED, ACCEL * 5.0)
	#else:
		#velocity = velocity.move_toward(Vector3.ZERO, ACCEL * 5.0)
	#
	#move_and_slide()
	
			
	if current_distance_to_target > distance_to_target/2:
		actor.velocity = actor.velocity.move_toward(direction * SPEED, ACCEL * 5.0)

	# If the distance to the target is less than the step, set the final position.
	if current_distance_to_target <= acceptance_radius:
		return SUCCESS
	else:
		# Otherwise, move towards the target
		actor.move_and_slide()
		return RUNNING

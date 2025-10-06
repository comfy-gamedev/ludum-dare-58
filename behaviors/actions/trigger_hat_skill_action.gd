class_name TriggerHatSkillAction
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	if not is_instance_valid(target):
		return FAILURE
	
	var target_pos = target.global_position
	#var direction = actor.global_position.direction_to(target_pos)
	
	var target_pos_vec2 = Vector2(target_pos.x, target_pos.z)
	var actor_pos_vec2 = Vector2(actor.position.x, actor.position.z)
	var direction = Vector3(target_pos_vec2.x - actor_pos_vec2.x, 0, target_pos_vec2.y - actor_pos_vec2.y).normalized()
	
	actor.trigger_hat_skill(direction, actor.get_parent())
	#get_tree().get_root()) # actor.get_parent())
	
	return SUCCESS

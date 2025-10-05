class_name SelectTargetAction
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	#if blackboard.get_value("target_locked", false):
		#return FAILURE
	
	var target: Node3D
	
	target = actor.get_closest_detected_target()
	
	if target != null:
		blackboard.set_value("target", target)
		return SUCCESS
	
	return FAILURE

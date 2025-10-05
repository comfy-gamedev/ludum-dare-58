class_name SelectTargetAction
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	#if blackboard.get_value("target_locked", false):
		#return FAILURE
	
	var target: Node3D
	
	target = actor.get_closest_detected_enemy_unit()
	
	if target != null:
		blackboard.set_value("target", target)
		return SUCCESS
	
	
	if target != null:
		blackboard.set_value("target", target)
		return SUCCESS
	
	return FAILURE

#func get_closest_any_range(actor: Node) -> Node2D:
	#var group = "Unit" if target_type == TargetType.UNIT else "Building"
	#
	#var all_enemies := get_tree().get_nodes_in_group(group) \
		#.filter(func(x): return x.team != actor.team)
	#
	#if target_type == TargetType.BUILDING:
		#all_enemies = all_enemies.filter(func (x): return x.is_targetable())
	#
	#var target = null
	#var min_dist = INF
	#
	#for i in all_enemies:
		#var dist = actor.global_position.distance_squared_to(i.global_position)
		#if dist < min_dist:
			#min_dist = dist
			#target = i
	#
	#return target

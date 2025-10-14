class_name RandomWaitAction
extends ActionLeaf

@export var min_wait_time: float = 1
@export var max_wait_time: float = 4
var wait_time:float = 0

func before_run(_actor: Node, _blackboard: Blackboard) -> void:
	wait_time = randf_range(min_wait_time, max_wait_time)

func tick(actor: Node, _blackboard: Blackboard) -> int:
	var delta = get_physics_process_delta_time()
	wait_time -= delta
	
	if wait_time > 0:
		actor.velocity = actor.velocity.move_toward(Vector3(0, actor.velocity.y, 0), delta * 5.0)
		#actor.move_and_slide()
		return RUNNING
	else:
		return SUCCESS

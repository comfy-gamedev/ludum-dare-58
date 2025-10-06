extends Area3D

var player_nearby = false
var player_interacting = false
var player_ref
var camera_origin_position_vec
	
func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("shoot"):
		if not player_interacting:
			on_player_interact(delta)

func on_player_interact(delta: float):
	player_interacting = true
	on_zoom_camera()
	print("interact")

func on_zoom_camera():
	if is_instance_valid(player_ref):
		var camera_node = player_ref.get_node("Camera3D")
		camera_origin_position_vec = camera_node.position
		camera_node.position = Vector3(0, 20, 10)

func on_reset_camera_position():
	if is_instance_valid(player_ref):
		var camera_node = player_ref.get_node("Camera3D")
		camera_node.position = camera_origin_position_vec

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		
		if not is_instance_valid(player_ref):
			player_ref = body

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		player_interacting = false
	
		on_reset_camera_position()

extends Area3D

var player_nearby = false
var player_interacting = false
var player_ref
var camera_original_rotation_vec
	
func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("shoot"):
		if not player_interacting:
			on_player_interact(delta)

func on_player_interact(_delta: float):
	player_interacting = true
	on_zoom_camera()
	print("interact")

func on_zoom_camera():
	if is_instance_valid(player_ref):
		var camera_node = player_ref.get_node("Camera3D")
		camera_original_rotation_vec = camera_node.rotation
		camera_node.global_position = Vector3(23, 1, 7)
		camera_node.rotation = Vector3(25, 0, 0)

func on_reset_camera_position():
	if is_instance_valid(player_ref):
		var camera_node = player_ref.get_node("Camera3D")
		camera_node.global_position = player_ref.position + Vector3(-0.01, 9.731, 6.336) #camera_original_position_vec
		camera_node.rotation = camera_original_rotation_vec

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

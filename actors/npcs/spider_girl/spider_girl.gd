extends Area3D

var player_nearby = false
var player_interacting = false
	
func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("shoot"):
		if not player_interacting:
			on_player_interact()

func on_player_interact():
	player_interacting = true
	print("interact")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		player_interacting = false

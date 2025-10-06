extends Area3D



#func _ready() -> void:
	#self.process_mode = Node.PROCESS_MODE_DISABLED


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("player <-> npc")
		#if Input.is_action_pressed("shoot") and 

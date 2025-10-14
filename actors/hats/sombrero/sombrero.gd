extends Hat


func _init() -> void:
	element = Globals.elements.AIR
	

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir
	bullet.size = 2
	bullet.element_type = element
	bullet_parent.add_child(bullet)

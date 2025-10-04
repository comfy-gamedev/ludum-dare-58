extends Hat


func _init() -> void:
	element = Globals.elements.FIRE
	projectile_size = 2
	

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir
	bullet.size = 2
	bullet.element_type = Globals.elements.FIRE
	bullet_parent.add_child(bullet)

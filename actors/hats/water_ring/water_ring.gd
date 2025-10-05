extends Hat


func _init() -> void:
	element = Globals.elements.WATER
	use_cooldown = 0.9

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir
	bullet.explosive = true
	bullet.lifetime = .01
	bullet.radius = 10
	bullet.element_type = Globals.elements.WATER
	bullet_parent.add_child(bullet)

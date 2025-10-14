extends Hat


func _init() -> void:
	element = Globals.elements.WATER
	use_cooldown = 1.5

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir
	bullet.explosive = true
	bullet.lifetime = .01
	bullet.radius = 15
	bullet.element_type = element
	bullet_parent.add_child(bullet)

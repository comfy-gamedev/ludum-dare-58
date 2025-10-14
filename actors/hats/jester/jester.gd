extends Hat


func _init() -> void:
	element = Globals.elements.EARTH
	use_cooldown = 0.8

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir
	bullet.speed *= 1.5
	bullet.element_type = element
	bullet.movement = base_bullet.movement_types.ORBITAL
	bullet_parent.add_child(bullet)

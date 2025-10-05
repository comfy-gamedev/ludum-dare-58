extends Hat


func _init() -> void:
	element = Globals.elements.EARTH
	use_cooldown = 0.4

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir
	bullet.lifetime /= 4
	bullet.element_type = Globals.elements.EARTH
	bullet_parent.add_child(bullet)

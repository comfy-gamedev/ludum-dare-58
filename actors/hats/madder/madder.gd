extends Hat


func _init() -> void:
	element = Globals.elements.EARTH
	use_cooldown = 1

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir
	#bullet.direction = dir.rotated(Vector3.UP, 0)
	bullet.lifetime = 4
	bullet.movement = base_bullet.movement_types.LOOPY
	bullet.element_type = element
	bullet_parent.add_child(bullet)
	
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir.rotated(Vector3.UP, TAU / 5)
	bullet.lifetime = 4
	bullet.movement = base_bullet.movement_types.LOOPY
	bullet.element_type = element
	bullet_parent.add_child(bullet)
	#
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir.rotated(Vector3.UP, (TAU * 2) / 5)
	bullet.lifetime = 4
	bullet.movement = base_bullet.movement_types.LOOPY
	bullet.element_type = element
	bullet_parent.add_child(bullet)
	
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir.rotated(Vector3.UP, (TAU * 3) / 5)
	bullet.lifetime = 4
	bullet.movement = base_bullet.movement_types.LOOPY
	bullet.element_type = element
	bullet_parent.add_child(bullet)
	
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir.rotated(Vector3.UP, (TAU * 4) / 5)
	bullet.lifetime = 4
	bullet.movement = base_bullet.movement_types.LOOPY
	bullet.element_type = element
	bullet_parent.add_child(bullet)

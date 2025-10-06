extends Hat

func _init() -> void:
	element = Globals.elements.FIRE
	use_cooldown = 1.0

func fire(dir: Vector3, bullet_parent: Node3D):
	
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir
	#bullet.direction = dir.rotated(Vector3.UP, 0)
	bullet.lifetime = 1
	bullet.size = 1
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.element_type = element
	bullet.homing = true
	bullet_parent.add_child(bullet)
	
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir.rotated(Vector3.UP, TAU / 3)
	bullet.lifetime = 1
	bullet.size = 1
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.element_type = element
	bullet.homing = true
	bullet_parent.add_child(bullet)
	#
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir.rotated(Vector3.UP, - TAU / 3)
	bullet.lifetime = 1
	bullet.size = 1
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.element_type = element
	bullet.homing = true
	bullet_parent.add_child(bullet)
	
	bullet_parent.add_child(bullet)

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
	bullet.lifetime = 1.5
	bullet.size = 1.5
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.element_type = element
	bullet_parent.add_child(bullet)
	
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir.rotated(Vector3.UP, TAU / 3)
	bullet.lifetime = 1.5
	bullet.size = 1.5
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.element_type = element
	bullet_parent.add_child(bullet)
	#
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir.rotated(Vector3.UP, - TAU / 3)
	bullet.lifetime = 1.5
	bullet.size = 1.5
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.element_type = element
	bullet_parent.add_child(bullet)
	
	#bullet.element_type = Globals.elements.FIRE
	#bullet.damage = 1
	#bullet.speed = 7.5
	#bullet.size = 1
	#bullet.lifetime = 1
	#bullet.movement = base_bullet.movement_types.STRAIGHT
	#bullet.piercing = 1
	#bullet.radius = 3.0 #only applied to orbital or pulse modes
	#bullet.explosive = false
	#bullet.slowing = false
	#bullet.homing = false
	
	bullet_parent.add_child(bullet)

	
	bullet_parent.add_child(bullet)

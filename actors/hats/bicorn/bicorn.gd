extends Hat

func _init() -> void:
	element = Globals.elements.FIRE
	use_cooldown = 5

func fire(dir: Vector3, bullet_parent: Node3D):
	
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir
	#bullet.direction = dir.rotated(Vector3.UP, 0)
	bullet.damage = 3
	bullet.lifetime = 2
	bullet.size = 3
	bullet.speed = 15
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.element_type = element
	bullet.explosive = true
	bullet.radius = 3.0
	
	bullet_parent.add_child(bullet)
	
	bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir.rotated(Vector3.UP, TAU / 3)
	bullet.lifetime = 0.01
	bullet.size = 1.5
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.element_type = element
	bullet.radius = 2.0
	bullet.explosive = true
	bullet_parent.add_child(bullet)
	#
	#sa

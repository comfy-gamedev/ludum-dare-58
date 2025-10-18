extends Hat

func _init() -> void:
	element = Globals.elements.FIRE
	use_cooldown = 1.0

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir
	
	#this block is where you change the values
	bullet.element_type = Globals.elements.WATER
	bullet.damage = 2
	bullet.speed = 4
	bullet.size = 1
	bullet.lifetime = 2
	bullet.movement = base_bullet.movement_types.LOOPY
	bullet.piercing = 1
	bullet.radius = 4.0 #only applied to orbital or pulse modes
	bullet.explosive = true
	bullet.slowing = false
	bullet.homing = false
	
	bullet_parent.add_child(bullet)

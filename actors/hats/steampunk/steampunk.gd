extends Hat

func _init() -> void:
	element = Globals.elements.FIRE
	use_cooldown = 0.5

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir
	
	#this block is where you change the values
	bullet.element_type = Globals.elements.FIRE
	bullet.damage = 1
	bullet.speed = 7.5
	bullet.size = 1
	bullet.lifetime = 2
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.piercing = 1
	bullet.radius = 3.0 #only applied to orbital or pulse modes
	bullet.explosive = false
	bullet.slowing = true
	bullet.homing = true
	
	bullet_parent.add_child(bullet)

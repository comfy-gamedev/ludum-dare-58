extends Hat
func _init() -> void:
	element = Globals.elements.FIRE
	use_cooldown = 0.75
	

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position
	bullet.position.y = 1
	bullet.direction = dir
	
	#this block is where you change the values
	bullet.element_type = element
	bullet.damage = 1
	bullet.speed = 8.5
	bullet.size = 1
	bullet.lifetime = 1.5
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.piercing = 1
	bullet.radius = 3.0 #only applied to orbital or pulse modes
	bullet.explosive = false
	bullet.slowing = false
	bullet.homing = false
	
	bullet_parent.add_child(bullet)

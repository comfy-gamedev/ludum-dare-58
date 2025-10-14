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
	
	#this block is where you change the values
	bullet.element_type = Globals.elements.AIR
	bullet.damage = 2
	bullet.speed = 12
	bullet.size = 2
	bullet.lifetime = 8
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.piercing = 1
	bullet.radius = 3.0 #only applied to orbital or pulse modes
	bullet.explosive = false
	bullet.slowing = false
	bullet.homing = false
	
	bullet_parent.add_child(bullet)

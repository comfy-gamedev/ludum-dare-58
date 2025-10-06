extends Hat

func _init() -> void:
	element = Globals.elements.FIRE
	use_cooldown = 0.1

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = position + (Vector3.DOWN * 2)
	bullet.direction = dir
	
	#this block is where you change the values
	bullet.element_type = Globals.elements.FIRE
	bullet.damage = 0.5
	bullet.speed = 7.5
	bullet.size = 0.5
	bullet.lifetime = 10
	bullet.movement = base_bullet.movement_types.ORBITAL
	bullet.piercing = 1
	bullet.radius = 2.0 #only applied to orbital or pulse modes
	bullet.explosive = false
	bullet.slowing = false
	bullet.homing = false
	
	add_child(bullet)

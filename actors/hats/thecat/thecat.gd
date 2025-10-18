extends Hat

func _init() -> void:
	element = Globals.elements.FIRE
	use_cooldown = 1.0

func fire(dir: Vector3, bullet_parent: Node3D):
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = global_position + (Vector3.DOWN * 2)
	bullet.direction = dir
	
	#this block is where you change the values
	bullet.element_type = Globals.elements.FIRE
	bullet.damage = 1
	bullet.speed = 8
	bullet.size = 2
	bullet.lifetime = 3
	bullet.movement = base_bullet.movement_types.LOOPY
	bullet.piercing = 1
	bullet.radius = 3.0 #only applied to orbital or pulse modes
	bullet.explosive = false
	bullet.slowing = false
	bullet.homing = true
	
	bullet_parent.add_child(bullet)

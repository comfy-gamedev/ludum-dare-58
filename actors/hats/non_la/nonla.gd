extends Hat

func _init() -> void:
	element = Globals.elements.FIRE
	use_cooldown = 0.1

func fire(dir: Vector3, bullet_parent: Node3D):
	
	## position.player.tscn = Vector3.mouse_position
	## I Don't know how to code this properly. Should relocate the player to the mouse position, on firing
	
	var bullet: base_bullet = bullet_scene.instantiate()
	bullet.team = self.team
	bullet.position = position + (Vector3.DOWN * 2)
	bullet.direction = dir
	
	#this block is where you change the values
	bullet.element_type = Globals.elements.FIRE
	bullet.damage = 3
	bullet.speed = 7.5
	bullet.size = 2
	bullet.lifetime = 0.01
	bullet.movement = base_bullet.movement_types.STRAIGHT
	bullet.piercing = 1
	bullet.radius = 3 #only applied to orbital or pulse modes
	bullet.explosive = true
	bullet.slowing = false
	bullet.homing = false
	
	add_child(bullet)

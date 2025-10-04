extends base_enemy

func _init() -> void:
	health = 3
	damage = 1
	speed = 3.0
	accel = 3.0

func on_hit(_damage: int):
	health -= _damage
	print("ouch! you hit me")
	
	if health <= 0:
		print("Gobbo died!")

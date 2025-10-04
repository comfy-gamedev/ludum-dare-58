extends base_bullet

var direction : Vector3

func _init() -> void:
	damage = 1
	speed = 7.5

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	basis = Basis.looking_at(direction, Vector3.UP, true)


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.on_hit(damage)

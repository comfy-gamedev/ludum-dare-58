extends base_bullet

var direction : Vector3
var angle_offset = 0.0
var exploded = false

@onready var mesh: MeshInstance3D = $missile/Missile
@onready var timer: Timer = $Lifetime
@onready var explosion: MeshInstance3D = $ExplosionTorus
@onready var detection_area = $Area3D
@onready var missile = $missile

func _ready() -> void:
	timer.start(lifetime)
	
	#switch on type for 3d model
	match element_type:
		Globals.elements.AIR:
			mesh.mesh.surface_get_material(0).albedo_color = Color("8fcccb")
		Globals.elements.WATER:
			mesh.mesh.surface_get_material(0).albedo_color = Color("457cd6")
		Globals.elements.FIRE:
			mesh.mesh.surface_get_material(0).albedo_color = Color("d46e33")
		Globals.elements.EARTH:
			mesh.mesh.surface_get_material(0).albedo_color = Color("57253b")

func _physics_process(delta: float) -> void:
	if exploded:
		#if explosion.scale.length() > Vector3.ONE.length() * .6:
		if explosion.scale.x > radius / 4.0:
			explosion.scale += Vector3.ONE * delta * (radius / 2.0)
			explosion.mesh.inner_radius += delta * 0.9
			detection_area.scale += Vector3.ONE * delta * radius
		else:
			explosion.scale += Vector3.ONE * delta * (radius / 2.0)
			detection_area.scale += Vector3.ONE * delta * radius
		return
	
	match movement:
		movement_types.STRAIGHT:
			position += direction * speed * delta
			basis = Basis.looking_at(direction, Vector3.UP, true)
			basis = basis.scaled(Vector3.ONE * size)
		movement_types.WAVY:
			position += direction * speed * delta
			basis = Basis.looking_at(direction, Vector3.UP, true)
			basis = basis.scaled(Vector3.ONE * size)
			angle_offset = sin((timer.wait_time - timer.time_left - (1.0 / 4.5)) * 2 * PI) / 8.0
			direction = direction.rotated(Vector3.UP, angle_offset)
		movement_types.LOOPY:
			position += direction * speed * delta
			basis = Basis.looking_at(direction, Vector3.UP, true)
			basis = basis.scaled(Vector3.ONE * size)
			angle_offset = (sin((timer.wait_time - timer.time_left - 1) * 2) + 1) / 10.0
			direction = direction.rotated(Vector3.UP, angle_offset)
		movement_types.ORBITAL:
			position += direction * speed * delta
			basis = Basis.looking_at(direction, Vector3.UP, true)
			basis = basis.scaled(Vector3.ONE * size)
			if position.length() > radius:
				direction = -position.cross(Vector3.UP).normalized()
			else:
				if angle_offset < 1.0 / 7.0:
					angle_offset += delta 
				direction = direction.rotated(Vector3.UP, angle_offset)


func _on_lifetime_timeout() -> void:
	if !explosive || exploded:
		queue_free()
	else:
		explode()

func _on_area_3d_body_entered(body: Node3D) -> void:
	var opponent_team_group
	
	if team == Globals.teams.ALLY:
		opponent_team_group = "enemy"
	elif team == Globals.teams.ENEMY:
		opponent_team_group = "ally"
		
	if body.is_in_group(opponent_team_group):
		body.on_hit(damage)
		piercing -= 1
		if piercing < 1:
			if !explosive:
				queue_free()
			elif !exploded:
				explode()

func explode():
	missile.visible = false
	exploded = true
	timer.start(1.0)
	detection_area.scale = Vector3.ONE * .2

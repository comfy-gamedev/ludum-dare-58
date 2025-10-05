extends base_bullet

var direction : Vector3
var angle_offset = Vector2.ZERO

@onready var mesh: MeshInstance3D = $missile/Missile
@onready var timer = $Lifetime

func _ready() -> void:
	#scale = Vector3.ONE * size
	timer.wait_time = lifetime
	
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


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	var opponent_team_group
	
	if team == Globals.teams.ALLY:
		opponent_team_group = "enemy"
	elif team == Globals.teams.ENEMY:
		opponent_team_group = "ally"
		
	if body.is_in_group(opponent_team_group):
		body.on_hit(damage)

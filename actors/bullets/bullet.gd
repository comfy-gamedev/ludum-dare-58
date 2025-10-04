extends base_bullet

var direction : Vector3

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	scale = Vector3.ONE * size
	#switch on type for 3d model
	match element_type:
		Globals.elements.AIR:
			mesh.mesh.material.albedo_color = Color("8fcccb")
		Globals.elements.WATER:
			mesh.mesh.material.albedo_color = Color("457cd6")
		Globals.elements.FIRE:
			mesh.mesh.material.albedo_color = Color("d46e33")
		Globals.elements.EARTH:
			mesh.mesh.material.albedo_color = Color("57253b")

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.on_hit(damage)

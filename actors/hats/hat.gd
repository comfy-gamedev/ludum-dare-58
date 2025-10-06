@abstract class_name Hat extends RigidBody3D

@onready var cooldown = $PickupCooldown
#@onready var bullet_parent = $"../../BulletParent"

var bullet_scene = preload("res://actors/bullets/bullet.tscn")

var team = Globals.teams.ALLY
var element = Globals.elements.EARTH
var use_cooldown = 1.0

var pickup_ready: bool:
	get:
		return cooldown.is_stopped()
	set(x):
		cooldown.start()

func _ready() -> void:
	match element:
		Globals.elements.AIR:
			$MeshInstance3D.mesh.surface_get_material(0).albedo_color = Color("8fcccb")
		Globals.elements.WATER:
			$MeshInstance3D.mesh.surface_get_material(0).albedo_color = Color("457cd6")
		Globals.elements.FIRE:
			$MeshInstance3D.mesh.surface_get_material(0).albedo_color = Color("d46e33")
		Globals.elements.EARTH:
			$MeshInstance3D.mesh.surface_get_material(0).albedo_color = Color("57253b")

func _physics_process(delta: float) -> void:
	rotate(Vector3.UP, delta * PI / 4.0)

@abstract
func fire(dir: Vector3, bullet_parent: Node3D)

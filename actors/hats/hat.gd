@abstract class_name Hat extends RigidBody3D

@onready var cooldown = $PickupCooldown
#@onready var bullet_parent = $"../../BulletParent"

var bullet_scene = preload("res://actors/bullets/bullet.tscn")

var team = Globals.teams.ALLY
var element = Globals.elements.EARTH
var use_cooldown = 1.0
var projectile_size = 1

var pickup_ready: bool:
	get:
		return cooldown.is_stopped()
	set(x):
		cooldown.start()

func _init() -> void:
	linear_velocity = Vector3(5, 0, 5)

@abstract
func fire(dir: Vector3, bullet_parent: Node3D)

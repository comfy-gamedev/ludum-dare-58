@abstract class_name base_enemy extends CharacterBody3D

var hat: Hat
var damage
var health
var speed
var accel
var attack_acceptance_range

@abstract func on_hit(_damage: int)

@abstract func get_closest_detected_target() -> Node3D

@abstract func trigger_hat_skill(dir: Vector3, bullet_parent: Node3D)

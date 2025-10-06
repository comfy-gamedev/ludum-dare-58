@abstract class_name base_unit extends CharacterBody3D

var equipped_hat: Hat
var encampment_ref: base_camp
var blackboard: Blackboard
var damage
var health
var speed
var accel
var attack_acceptance_range
var origin_position
var max_distance_from_origin

@abstract func on_hit(_damage: int, type: Globals.elements, slowing: bool)

@abstract func get_closest_detected_target() -> Node3D

@abstract func trigger_hat_skill(dir: Vector3, bullet_parent: Node3D)

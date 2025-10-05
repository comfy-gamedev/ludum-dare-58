@abstract class_name base_enemy extends CharacterBody3D

var damage
var health
var speed
var accel
var attack_acceptance_range

@abstract func on_hit(damage: int)

@abstract func get_closest_detected_target() -> Node3D

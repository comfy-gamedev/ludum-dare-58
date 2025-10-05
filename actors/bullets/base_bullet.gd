@abstract class_name base_bullet extends Node3D

var damage = 1
var speed = 7.5
var size = 1
var element_type = Globals.elements.EARTH
var lifetime = 10.5
var movement = movement_types.LOOPY

enum movement_types {
	STRAIGHT,
	LOOPY,
	ORBITAL,
	WAVY
}

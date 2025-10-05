@abstract class_name base_bullet extends Node3D

var damage = 1
var speed = 7.5
var size = 1
var element_type = Globals.elements.EARTH
var lifetime = 1.5
var movement = movement_types.STRAIGHT
var team = Globals.teams.ENEMY
var piercing = 1
var radius = 3.0 #only applied to orbital or pulse modes
var explosive = false
var slowing = false
var homing = true

enum movement_types {
	STRAIGHT,
	LOOPY,
	ORBITAL, #special, need to set bullet parent = hat
	WAVY
}

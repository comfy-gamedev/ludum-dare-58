extends Node
## An empty global variable bag with a togglable debug overlay that displays all variables.
##
## Designed to hold simple global variables.
## A bad pattern, but in a game jam, sometimes you just need to get it done.
##
## Displays a debug overlay when the user hits the F1 key.
## All variables are displayed automatically.

enum teams {
	ALLY,
	ENEMY
}

enum elements {
	AIR,
	FIRE,
	WATER,
	EARTH
}

var hat_scene_pool = {
	BEEF = preload("res://actors/hats/beefeater/beefeater.tscn"),
	BERET = preload("res://actors/hats/beret/beret.tscn"),
	BICORN = preload("res://actors/hats/bicorn/bicorn.tscn"),
	BUFFALO = preload("uid://dgn2cmxmyhrcx"),
	BUNNY = preload("res://actors/hats/bunny/bunny.tscn"),
	COWBOY = preload("res://actors/hats/cowboy/cowboy.tscn"),
	FEZ = preload("uid://5mtoxf8e7jpa"),
	JESTER = preload("uid://dbwi51ka8rab7"),
	MADDER = preload("uid://dx8wgsi14wwb3"),
	MORTAR = preload("res://actors/hats/mortarboard/mortarboard.tscn"),
	NON_LA = preload("res://actors/hats/non_la/nonla.tscn"),
	PHRYGIAN = preload("uid://cpymafqtgeuud"),
	SCALLY = preload("uid://da6xpkw71ms42"),
	SOMBRERO = preload("res://actors/hats/sombrero/sombrero.tscn"),
	STEAMPUNK = preload("res://actors/hats/steampunk/steampunk.tscn"),
	THECAT = preload("res://actors/hats/thecat/thecat.tscn"),
	TRICORN = preload("res://actors/hats/tricorn/tricorn.tscn"),
	TYROLEAN = preload("res://actors/hats/tyrolean/tyrolean.tscn"),
	WITCH = preload("res://actors/hats/witch/witch.tscn"),
}

var caplings_rescued = 0

## Emitted when any variable changes.
signal changed(prop_name: StringName)

signal yarn_balls_changed()

var yarn_balls: int = 0:
	set(v): yarn_balls = v; changed.emit(); yarn_balls_changed.emit()

## Example variable.
var player_health: int = 0:
	set(v):
		if player_health == v: return
		player_health = v
		_notify_changed(&"player_health")


## Reset all variables to their default state.
func reset():
	for prop_name in _defaults:
		set(prop_name, _defaults[prop_name])

#region Plumbing
var _defaults: Dictionary[StringName, Variant] = {}

func _notify_changed(prop_name: StringName) -> void:
	changed.emit(prop_name)

func _init() -> void:
	for prop in get_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			_defaults[prop.name] = get(prop.name)
#endregion

#region Debug overlay
var _overlay
func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed:
		match event.physical_keycode:
			KEY_F1:
				if not _overlay:
					_overlay = load("res://autoload/globals/globals_overlay.tscn").instantiate()
					get_parent().add_child(_overlay)
				else:
					_overlay.visible = not _overlay.visible
#endregion

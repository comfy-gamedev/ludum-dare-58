extends base_enemy

@onready var blackboard: Blackboard = $Blackboard
@onready var target_seeking_radius: Area3D = $TargetSeekingRadius

var hat_drop_scene = preload("res://actors/hats/icicle/icicle_hat.tscn")

func _init() -> void:
	health = 3
	damage = 1
	speed = 3.0
	accel = 3.0

func _physics_process(_delta: float) -> void:
	seek_targets()

func seek_targets():
	var bodies = target_seeking_radius.get_overlapping_bodies().filter(func (x): return x.is_in_group("ally"))
	blackboard.set_value("target_objects", bodies)

func on_hit(_damage: int):
	health -= _damage
	
	if health <= 0:
		on_death()

func on_death():
	spawn_hat_drop()
	self.queue_free()

func spawn_hat_drop():
	var new_hat_drop = hat_drop_scene.instantiate()
	var hat_drop_pos = Vector3(self.global_position.x, 0, self.global_position.z)
	new_hat_drop.set_position(hat_drop_pos)
	self.get_parent().add_child(new_hat_drop)

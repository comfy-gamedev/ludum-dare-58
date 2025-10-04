extends Node3D

var damage = 1
var speed = 7.5
var direction : Vector3

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_lifetime_timeout() -> void:
	queue_free()

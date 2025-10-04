extends Node3D

const chunk_size = Vector3(2*16, 0, 2*16)
const world_size = Vector2(10, 10)

var default_chunks = [
	preload("res://level_chunks/horse.tscn"),
	preload("res://level_chunks/test.tscn"),
]

func _ready() -> void:
	for i in world_size.x:
		for j in world_size.y:
			var chunk = default_chunks.pick_random().instantiate()
			chunk.name = "Chunk_%s_%s" % [i, j]
			chunk.position = Vector3(i - 5, 0, -j + 5) * chunk_size
			add_child(chunk)

extends Node3D

const chunk_size = Vector3(2*16, 0, 2*16)
const world_size = Vector2(11, 11)

var home_chunk = preload("res://level_chunks/home.tscn")

var default_chunks = [
	preload("res://level_chunks/fields/horse.tscn"),
	preload("res://level_chunks/fields/test.tscn"),
]

func _ready() -> void:
	for i in world_size.x:
		for j in world_size.y:
			var chunk
			if i == floori(world_size.x / 2) and j == floori(world_size.y / 2):
				chunk = home_chunk.instantiate()
			else:
				chunk = default_chunks.pick_random().instantiate()
			chunk.name = "Chunk_%s_%s" % [i, j]
			chunk.position = Vector3(i - world_size.x / 2.0, 0, -j + world_size.y / 2.0) * chunk_size
			add_child(chunk)

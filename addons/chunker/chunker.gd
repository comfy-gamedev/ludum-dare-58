@tool
extends Node
class_name Chunker

const OFFSETS = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1)]

@export var chunk_size: Vector2 = Vector2(32.0, 32.0)

@export_storage var chunk_scenes: Array[String] = []
@export_storage var chunks: Dictionary[Vector2i, Array] = {}

var _loaded_chunks: Dictionary[Vector2i, Node3D] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for p in chunks:
		_reload_chunk(p)

func get_chunk(p: Vector2i) -> Array:
	if p in chunks:
		return [chunk_scenes[chunks[p][0]], chunks[p][1]]
	else:
		return []

func set_chunk(p: Vector2i, chunk_scene: String, orientation: int) -> void:
	var i = chunk_scenes.find(chunk_scene)
	if i == -1:
		chunk_scenes.append(chunk_scene)
		i = chunk_scenes.size() - 1
	chunks[p] = [i, orientation]
	_reload_chunk(p)

func erase_chunk(p: Vector2i) -> void:
	chunks.erase(p)
	_reload_chunk(p)

func _reload_chunk(p: Vector2i) -> void:
	if p in _loaded_chunks:
		_loaded_chunks[p].queue_free()
		_loaded_chunks.erase(p)
	if p in chunks:
		_loaded_chunks[p] = load(chunk_scenes[chunks[p][0]]).instantiate()
		var chunk_p = p + Chunker.OFFSETS[chunks[p][1]]
		_loaded_chunks[p].position = Vector3(chunk_p.x * chunk_size.x, 0, -chunk_p.y * chunk_size.y)
		_loaded_chunks[p].rotation.y = (chunks[p][1] / 4.0) * TAU
		for c in _loaded_chunks[p].get_children():
			if c is DirectionalLight3D:
				c.free()
		add_child(_loaded_chunks[p], false, Node.INTERNAL_MODE_BACK)

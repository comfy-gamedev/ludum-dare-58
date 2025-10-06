@tool
extends Node3D
class_name Chunker

const OFFSETS = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1)]

const DECALS = [4, 5, 6, 7, 8, 35]

@export var chunk_size: Vector2 = Vector2(32.0, 32.0)

@export_storage var chunk_scenes: Array[String] = []
@export_storage var chunks: Dictionary[Vector2i, Array] = {}

var _loaded_chunks: Dictionary[Vector2i, Node3D] = {}

var _cached_load: Dictionary[int, PackedScene] = {}

var _meshlib_copy: MeshLibrary

var _cells_to_bump: Array[Vector3i] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for p in chunks:
		_reload_chunk(p)

func _get_aabb() -> AABB:
	return AABB(Vector3.ZERO, Vector3.ONE)

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
		if chunks[p][0] not in _cached_load:
			_cached_load[chunks[p][0]] = load(chunk_scenes[chunks[p][0]])
		_loaded_chunks[p] = _cached_load[chunks[p][0]].instantiate()
		var chunk_p = p + Chunker.OFFSETS[chunks[p][1]]
		_loaded_chunks[p].position = Vector3(chunk_p.x * chunk_size.x, 0, -chunk_p.y * chunk_size.y)
		_loaded_chunks[p].rotation.y = (chunks[p][1] / 4.0) * TAU
		_cleanup_chunk(_loaded_chunks[p], chunks[p][1])
		add_child(_loaded_chunks[p], false, Node.INTERNAL_MODE_BACK)

func _cleanup_chunk(node: GridMap, spin: int) -> void:
	if not node:
		return
	
	if not _meshlib_copy:
		_meshlib_copy = node.mesh_library.duplicate()
		for i in _meshlib_copy.get_item_list():
			var j = i + 1000
			_meshlib_copy.create_item(j)
			_meshlib_copy.set_item_mesh(j, _meshlib_copy.get_item_mesh(i))
	
	node.cell_octant_size = 16
	node.mesh_library = _meshlib_copy
	
	for v in node.get_used_cells():
		var c = node.get_cell_item(v)
		if not _meshlib_copy.get_item_shapes(c):
			continue
		if v.y < 0:
			_cells_to_bump.append(v)
		else:
			var ii = 0
			for vv in [Vector3i(1, 0, 0), Vector3i(-1, 0, 0), Vector3i(0, 0, -1), Vector3i(0, 0, 1)]:
				if node.get_cell_item(v + vv) == c:
					ii += 1
			if ii == 4:
				if c == 2 or node.get_cell_item(v + Vector3i(0, 1, 0)) == c:
					_cells_to_bump.append(v)
		#if c in DECALS:
			#o = node.get_orthogonal_index_from_basis(Basis(Vector3.UP, ((3 - spin) / 4.0) * TAU))
	
	for v in _cells_to_bump:
		var c = node.get_cell_item(v)
		var o = node.get_cell_item_orientation(v)
		node.set_cell_item(v, c + 1000, o)
	
	_cells_to_bump.clear()

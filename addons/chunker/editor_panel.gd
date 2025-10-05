@tool
extends VBoxContainer

var plugin: EditorPlugin

var is_spatial: bool = false

var node: Chunker

var orientation: int = 0

var preview_chunk_uid: String
var preview_cursor_position: Vector3
var preview_chunk: Node3D

@onready var item_list: ItemList = $ItemList

func _ready() -> void:
	set_process(node != null)
	_collect_items()
	EditorInterface.get_resource_filesystem().filesystem_changed.connect(func (): _on_refresh_button_pressed())

func _process(delta: float) -> void:
	pass


func _collect_items() -> void:
	var selected_uid = Array(item_list.get_selected_items()).map(func (i): return item_list.get_item_metadata(i))
	print({ selected_uid = selected_uid })
	item_list.clear()
	_collect_items_populate()
	if selected_uid:
		for i in item_list.item_count:
			if item_list.get_item_metadata(i) == selected_uid[0]:
				item_list.select(i)
				break

func _collect_items_populate(from: String = "res://level_chunks") -> void:
	for d in DirAccess.get_files_at(from):
		if d.begins_with("_"):
			continue
		var fullpath = from.path_join(d)
		var uid = ResourceUID.path_to_uid(fullpath)
		
		var i = item_list.item_count
		item_list.add_item(d.trim_suffix(".tscn"))
		item_list.set_item_metadata(i, uid)
		item_list.set_item_tooltip(i, fullpath)
		EditorInterface.get_resource_previewer().queue_resource_preview(uid, self, &"_preview_ready", { uid = uid, i = i })
	for d in DirAccess.get_directories_at(from):
		_collect_items_populate(from.path_join(d))

func _preview_ready(path: String, preview: Texture2D, thumbnail_preview: Texture2D, userdata: Variant) -> void:
	if item_list.get_item_metadata(userdata.i) != userdata.uid:
		return
	item_list.set_item_icon(userdata.i, preview)

func edit(object: Chunker) -> void:
	node = object
	set_process(node != null)


func forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) -> int:
	if not node or not is_spatial or Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return EditorPlugin.AFTER_GUI_INPUT_PASS
	
	if not item_list.is_anything_selected():
		print('UH OH')
		return EditorPlugin.AFTER_GUI_INPUT_STOP
	
	var selected_i = item_list.get_selected_items()[0]
	var uid = item_list.get_item_metadata(selected_i)
	if not uid:
		print('UH OH')
		return EditorPlugin.AFTER_GUI_INPUT_STOP
	
	if event is InputEventKey:
		if event.pressed and event.physical_keycode == KEY_S and event.get_modifiers_mask() == 0:
			orientation = (orientation + 1) % 4
			_update_preview(uid)
			return EditorPlugin.AFTER_GUI_INPUT_STOP
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var origin = viewport_camera.project_ray_origin(event.position)
			var normal = viewport_camera.project_ray_normal(event.position)
			var hit = Plane(Vector3.UP, Vector3.ZERO).intersects_ray(origin, normal)
			var chunk_p = Vector2i((Vector2(hit.x, -hit.z) / node.chunk_size).floor())
			
			if event.shift_pressed:
				var existing = node.get_chunk(chunk_p)
				if not existing:
					return EditorPlugin.AFTER_GUI_INPUT_STOP
				plugin.get_undo_redo().create_action("Erase chunk")
				plugin.get_undo_redo().add_do_method(node, "erase_chunk", chunk_p)
				plugin.get_undo_redo().add_undo_method(node, "set_chunk", chunk_p, existing[0], existing[1])
				plugin.get_undo_redo().commit_action()
				EditorInterface.mark_scene_as_unsaved()
				return EditorPlugin.AFTER_GUI_INPUT_STOP
			else:
				var existing = node.get_chunk(chunk_p)
				if existing == [uid, orientation]:
					return EditorPlugin.AFTER_GUI_INPUT_STOP
				plugin.get_undo_redo().create_action("Set chunk")
				plugin.get_undo_redo().add_do_method(node, "set_chunk", chunk_p, uid, orientation)
				if existing:
					plugin.get_undo_redo().add_undo_method(node, "set_chunk", chunk_p, existing[0], existing[1])
				else:
					plugin.get_undo_redo().add_undo_method(node, "erase_chunk", chunk_p)
				plugin.get_undo_redo().commit_action()
				EditorInterface.mark_scene_as_unsaved()
				return EditorPlugin.AFTER_GUI_INPUT_STOP
	
	if event is InputEventMouseMotion:
		_update_preview_cursor_position(viewport_camera, event)
		_update_preview(uid)
		return EditorPlugin.AFTER_GUI_INPUT_STOP
	
	return EditorPlugin.AFTER_GUI_INPUT_PASS

func _update_preview(uid: String) -> void:
	if preview_chunk_uid != uid:
		if is_instance_valid(preview_chunk):
			preview_chunk.queue_free()
		preview_chunk_uid = uid
		preview_chunk = load(uid).instantiate()
		EditorInterface.get_edited_scene_root().get_parent().add_child(preview_chunk, false, Node.INTERNAL_MODE_BACK)
	
	var hit = preview_cursor_position
	var chunk_p = Vector2i((Vector2(hit.x, -hit.z) / node.chunk_size).floor())
	chunk_p += Chunker.OFFSETS[orientation]
	
	preview_chunk.position = Vector3(chunk_p.x * node.chunk_size.x, 0, -chunk_p.y * node.chunk_size.y)
	preview_chunk.rotation.y = (orientation / 4.0) * TAU

func _update_preview_cursor_position(viewport_camera: Camera3D, event: InputEventMouse) -> void:
	var origin = viewport_camera.project_ray_origin(event.position)
	var normal = viewport_camera.project_ray_normal(event.position)
	preview_cursor_position = Plane(Vector3.UP, Vector3.ZERO).intersects_ray(origin, normal)

func _on_refresh_button_pressed() -> void:
	_collect_items()

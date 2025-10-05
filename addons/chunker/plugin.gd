@tool
extends EditorPlugin

var editor_panel: CanvasItem
var current_screen: String

func _enable_plugin() -> void:
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	main_screen_changed.connect(_on_main_screen_changed)
	editor_panel = preload("editor_panel.tscn").instantiate()
	editor_panel.plugin = self
	add_control_to_bottom_panel(editor_panel, "Chunks")


func _exit_tree() -> void:
	if is_instance_valid(editor_panel):
		remove_control_from_bottom_panel(editor_panel)
		editor_panel.queue_free()

func _on_main_screen_changed(what: String) -> void:
	current_screen = what
	if is_instance_valid(editor_panel):
		editor_panel.is_spatial = what == "3D"

func _handles(object: Object) -> bool:
	return object is Chunker

func _edit(object: Object) -> void:
	editor_panel.edit(object)

func _make_visible(visible: bool) -> void:
	if not is_instance_valid(editor_panel):
		return
	
	if visible:
		make_bottom_panel_item_visible(editor_panel)
		editor_panel.set_process(true)
	else:
		if editor_panel.is_visible_in_tree():
			hide_bottom_panel()
		editor_panel.set_process(false)
		editor_panel.preview_chunk.queue_free()
		editor_panel.preview_chunk_uid = ""

func _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) -> int:
	return editor_panel.forward_3d_gui_input(viewport_camera, event)

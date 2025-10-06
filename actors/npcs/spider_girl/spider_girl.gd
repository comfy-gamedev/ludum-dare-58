extends Area3D

var player_nearby = false
var player_interacting = false
var player_ref
var camera_original_rotation_vec
var camera_origin_position_vec

@onready var dialog_panel: Panel = %DialogPanel
@onready var dialog_label: Label = %DialogLabel
@onready var dialog_button: Button = %DialogButton

@onready var catalog_panel: Panel = %CatalogPanel
@onready var dispense_button: Button = %DispenseButton
@onready var exit_button: Button = %ExitButton

func _ready() -> void:
	init_hat_catalog_items()

func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("shoot"):
		if not player_interacting:
			on_player_interact(delta)

func on_player_interact(_delta: float):
	player_interacting = true
	on_zoom_camera()
	intro_dialog()

func on_zoom_camera():
	if is_instance_valid(player_ref):
		var camera_node = player_ref.get_node("Camera3D")
		camera_original_rotation_vec = camera_node.rotation
		camera_node.global_position = Vector3(23, 1, 7)
		camera_node.rotation = Vector3(25, 0, 0)

func on_reset_camera_position():
	if is_instance_valid(player_ref) and player_interacting:
		player_interacting = false
		var camera_node = player_ref.get_node("Camera3D")
		camera_node.global_position = player_ref.position + Vector3(-0.01, 9.731, 6.336) #camera_original_position_vec
		camera_node.rotation = camera_original_rotation_vec

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		
		if not is_instance_valid(player_ref):
			player_ref = body
	if body.is_in_group("hat"):
		body.queue_free()

func on_exit_interaction():	
	on_reset_camera_position()
	on_reset_ui()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
	
	on_exit_interaction()

func on_reset_ui():
	dialog_panel.visible = false
	catalog_panel.visible = false


func intro_dialog() -> void:
	catalog_panel.visible = true
	dialog_panel.visible = true
	Messages.freeze_game.emit(true)
	await dialog_say("Get these little freaks off my lawn.")
	await dialog_say("They lost all my hats and now the greedy grabbers are coming. If you save the captured ones they'll help defend this spot.")
	await dialog_say("Toss hats to them to empower them. Bring me hats and I'll make you new ones.")
	Messages.freeze_game.emit(false)
	dialog_panel.visible = false
	catalog_panel.visible = false

func dialog_say(s: String) -> void:
	dialog_label.text = s
	dialog_label.visible_ratio = 0.0
	var tween = create_tween()
	tween.tween_property(dialog_label, "visible_ratio", 1.0, 0.5)
	dialog_button.disabled = true
	await tween.finished
	dialog_button.disabled = false
	await dialog_button.pressed
	
	dialog_panel.visible = false
	catalog_panel.visible = false

func init_hat_catalog_items():
	var button_pos_y = -90
	var button_pos_x = 15
	var hat_index = 0
	
	for r in range(3):
		button_pos_y += 105
		button_pos_x = 15
		
		for c in range(4):
			#var mission_id = ""
			#mission_number += 1
			#
			#if mission_number < 10:
				#mission_id += "0"
				#mission_id += str(mission_number)
			#else:
				#mission_id += str(mission_number)
				
			create_hat_catalog_item(Vector2(button_pos_x, button_pos_y), hat_index)
			hat_index += 1
			button_pos_x += 105
	
func create_hat_catalog_item(pos: Vector2, hat_index):
	var item_height = 100
	var item_length = 100
	var new_item_panel = Button.new()
	new_item_panel.disabled = true
	new_item_panel.set_position(pos)
	new_item_panel.set_size(Vector2(item_length, item_height))
	#new_item_panel.theme = ui_theme
	#Globals.hat_scene_pool
	catalog_panel.add_child(new_item_panel)
	
	var hat_keys = Globals.hat_scene_pool.keys()
	if hat_index <= hat_keys.size():
		var current_hat_key = hat_keys[hat_index]
		var current_hat_scene = Globals.hat_scene_pool[current_hat_key]
		var hat = current_hat_scene.instantiate()
		
		var sub_viewport_container = SubViewportContainer.new()
		var sub_viewport = SubViewport.new()
		sub_viewport.transparent_bg = true
		#new_item_panel.add_child(sub_viewport_container)
		sub_viewport_container.add_child(sub_viewport)
		#sub_viewport.size = Vector2i(100, 100)
		sub_viewport_container.stretch = true
		sub_viewport_container.size = Vector2i(100, 100)
		sub_viewport.add_child(Camera3D.new())
		sub_viewport.add_child(hat)
		sub_viewport.own_world_3d = true
		var directional_light = DirectionalLight3D.new()
		directional_light.light_energy = 0.75
		directional_light.rotation = Vector3(-45, 45, 0)
		sub_viewport.add_child(directional_light)
		new_item_panel.add_child(sub_viewport_container)
		hat.position.z = -2
		hat.process_mode = Node.PROCESS_MODE_DISABLED
		#new_item_panel.add_child(sub_viewport)
		#sub_viewport.texture = 
		#sub_viewport.add_child(hat)
		#var viewport = new Viewport()
		#hat.global_position = Vector3(pos.x, pos.y, 0)
	#var hat_drop_pos = Vector3(self.global_position.x, 0, self.global_position.z)
		#new_item_panel.add_child(hat)
	else:
		new_item_panel.text = "?"

func _on_exit_button_pressed() -> void:
	on_exit_interaction()

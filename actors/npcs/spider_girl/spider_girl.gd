extends Area3D

var player_nearby = false
var player_interacting = false
var player_ref
var camera_original_basis
var camera_original_position_vec
var yarn: int = 0

@onready var catalog_control: Control = %Catalog
@onready var catalog_items_panel: Panel = %CatalogItemsPanel
@onready var dialog_panel: Panel = %DialogPanel
@onready var hat_name_label: Label = %HatNameLabel
@onready var dialog_label: Label = %DialogLabel
@onready var dialog_button: Button = %DialogButton
@onready var prev_button: Button = %PrevButton
@onready var next_button: Button = %NextButton
@onready var close_button: Button = %CloseButton
@onready var yay: CPUParticles3D = $Yay
@onready var player_marker: Marker3D = $PlayerMarker3D
@onready var camera_marker: Marker3D = $CameraMarker3D

var collected_hats = {
	"res://actors/hats/beefeater/beefeater.tscn" = {
		"name": "Beefeater",
		"count": 0,
		"tween": null,
		"dialog": "The beefeater hat. Great! You guard the palace, I'll guard the food. We all have our roles now."
	},
	"res://actors/hats/beret/beret.tscn" = {
		"name": "Beret",
		"count": 0,
		"tween": null,
		"dialog": "The beret hat. If you start snapping your fingers and reading poetry, I'm crawling outta here."
	},
	"res://actors/hats/bicorn/bicorn.tscn" = {
		"name": "Bicorn",
		"count": 0,
		"tween": null,
		"dialog": "The bicorn hat. That hat's got adventure written all over it. Smells like salt, glory... and maybe old socks."
	},
	"res://actors/hats/buffalo/buffalo.tscn" = {
		"name": "Buffalo",
		"count": 0,
		"tween": null,
		"dialog": "The buffalo hat. Big hat energy! Don't go stampeding through my webs, okay?"
	},
	"res://actors/hats/cowboy/cowboy.tscn" = {
		"name": "Cowboy",
		"count": 0,
		"tween": null,
		"dialog": "The cowboy hat. Yeehaw! Careful, I bite faster than your six-shooter."
	},
	"res://actors/hats/fez/fez.tscn" = {
		"name": "Fez",
		"count": 0,
		"tween": null,
		"dialog": "The fez hat. Let me guess... you just came back from 'studying ancient ruins,' huh?"
	},
	"res://actors/hats/jester/jester.tscn" = {
		"name": "Jester",
		"count": 0,
		"tween": null,
		"dialog": "The jester hat. Oh good, now your jokes have context."
	},
	"res://actors/hats/madder/madder.tscn" = {
		"name": "Madder",
		"count": 0,
		"tween": null,
		"dialog": "The madder hat. Heehee! Careful, wear that too long and you'll start arguing with your own reflection!"
	},
	"res://actors/hats/mortarboard/mortarboard.tscn" = {
		"name": "Mortarboard",
		"count": 0,
		"tween": null,
		"dialog": "The mortarboard hat. Look at you, thinking you're all smart now. Can you even spell 'arachnid?'"
	},
	"res://actors/hats/phrygian/phrygian.tscn" = {
		"name": "Phrygian",
		"count": 0,
		"tween": null,
		"dialog": "The phrygian hat. Rebel chic, huh? Just don't expect me to join your manifesto... I've got my own silk to spin."
	},
	"res://actors/hats/scally/scally.tscn" = {
		"name": "Scally",
		"count": 0,
		"tween": null,
		"dialog": "The scally hat. You look like you should be narrating a crime documentary."
	},
	"res://actors/hats/sombrero/sombrero.tscn" = {
		"name": "Sombrero",
		"count": 0,
		"tween": null,
		"dialog": "The sombrero hat. Ay, caramba! If I didn't have eight left feet I'd probably start dancing right about now."
	},
	"res://actors/hats/tricorn/tricorn.tscn" = {
		"name": "Tricorn",
		"count": 0,
		"tween": null,
		"dialog": "The tricorn hat. You're one swash short of a buckle, matey."
	},
	"res://actors/hats/tyrolean/tyrolean.tscn" = {
		"name": "Tyrolean",
		"count": 0,
		"tween": null,
		"dialog": "The tyrolean hat. Did you lose a wrestling match with a bird for that accessory?"
	},
	"res://actors/hats/witch/witch.tscn" = {
		"name": "Witch",
		"count": 0,
		"tween": null,
		"dialog": "The witch hat. This hat screams 'I read forbidden books for fun.'"
	},
}

func _ready() -> void:
	dialog_button.focus_mode = Control.FOCUS_NONE
	close_button.focus_mode = Control.FOCUS_NONE
	prev_button.focus_mode = Control.FOCUS_NONE
	next_button.focus_mode = Control.FOCUS_NONE
	catalog_control.visible = false
	dialog_panel.visible = false
	hat_name_label.text = ""

func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("shoot"):
		if not player_interacting:
			on_player_interact(delta)

func on_player_interact(_delta: float):
	player_interacting = true
	on_zoom_camera()
	intro_dialog()
	render_catalog_page(0)

func render_catalog_page(starting_hat_index: int):
	# Wipe previously rendered catalog items.
	for child in catalog_items_panel.get_children():
		child.queue_free()
		
	init_hat_catalog_items(starting_hat_index)

func on_zoom_camera():
	if is_instance_valid(player_ref):
		player_ref.global_position = player_marker.global_position
		player_ref.model.global_basis = player_marker.global_basis
		var camera_node = player_ref.get_node("Camera3D")
		camera_original_position_vec = camera_node.position
		camera_original_basis = camera_node.basis
		camera_node.global_position = camera_marker.global_position
		camera_node.global_basis = camera_marker.global_basis

func on_reset_camera_position():
	if is_instance_valid(player_ref) and player_interacting:
		player_interacting = false
		var camera_node = player_ref.get_node("Camera3D")
		camera_node.position = camera_original_position_vec
		camera_node.basis = camera_original_basis

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		
		if not is_instance_valid(player_ref):
			player_ref = body
			
	if body.is_in_group("hat") and not body.is_in_group("spiderhat"):
		# Register newly collected hat.
		if collected_hats.has(body.scene_file_path):
			collected_hats[body.scene_file_path].count += 1
		
		body.queue_free()
		yay.emitting = true
		yarn += 1
		if yarn == 3:
			yarn = 0
			yeet_hat()

func catalog_hat():
	pass

func yeet_hat() -> void:
	var hat: RigidBody3D = Globals.hat_scene_pool[Globals.hat_scene_pool.keys().pick_random()].instantiate()
	hat.add_to_group("spiderhat")
	hat.linear_velocity = Vector3(randf_range(-1,1), 1, randf_range(-1,1))
	get_parent().add_child(hat)
	hat.global_position = global_position + Vector3(0, 1, 0)
	print("Yeet ", hat)
	await get_tree().create_timer(5.0).timeout
	if is_instance_valid(hat):
		hat.remove_from_group("spiderhat")

func on_exit_interaction():
	on_reset_camera_position()
	on_reset_ui()
	Messages.freeze_game.emit(false)
	dialog_panel.visible = false
	catalog_control.visible = false

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
	
	on_exit_interaction()

func on_reset_ui():
	dialog_panel.visible = false
	catalog_control.visible = false

func intro_dialog() -> void:
	catalog_control.visible = true
	dialog_panel.visible = true
	Messages.freeze_game.emit(true)
	if Settings.a11y_arachnophobia:
		await dialog_say("I'm a horse.")
	await dialog_say("Get these little freaks off my lawn.")
	await dialog_say("They lost all my hats and now the greedy grabbers are coming. If you save the captured ones they'll help defend this spot.")
	await dialog_say("Toss hats to them to empower them. Bring me hats and I'll make you new ones.")
	on_exit_interaction()

func dialog_say(s: String) -> void:
	dialog_label.text = s
	dialog_label.visible_ratio = 0.0
	var tween = create_tween()
	tween.tween_property(dialog_label, "visible_ratio", 1.0, 0.5)
	dialog_button.disabled = true
	await tween.finished
	dialog_button.disabled = false
	await dialog_button.pressed

func init_hat_catalog_items(starting_hat_index: int):
	var button_pos_y = -90
	var button_pos_x = 15
	var hat_index = starting_hat_index
	
	# Enable / disable prev & next buttons based on index.
	# Note: This is hard coded for now, will need to track pages when we have > 24 hats.
	if hat_index == 0:
		prev_button.disabled = true
		next_button.disabled = false
	else:
		prev_button.disabled = false
		next_button.disabled = true
	
	for r in range(3):
		button_pos_y += 105
		button_pos_x = 15
		
		for c in range(4):
			create_hat_catalog_item(Vector2(button_pos_x, button_pos_y), hat_index)
			hat_index += 1
			button_pos_x += 105
	
func create_hat_catalog_item(pos: Vector2, hat_index: int):	
	var hat_keys = collected_hats.keys()
	
	# Render hat button panel if index is within hat list size.
	if hat_index < hat_keys.size():
		var hat_scene_file = hat_keys[hat_index]
		var item_height = 100
		var item_length = 100
		var new_hat_button_panel = Button.new()
		#new_hat_button_panel.focus_mode = Control.FOCUS_CLICK
		new_hat_button_panel.set_position(pos)
		new_hat_button_panel.set_size(Vector2(item_length, item_height))
		catalog_items_panel.add_child(new_hat_button_panel)
		
		if collected_hats[hat_scene_file].count >= 0:
			# Add additional dialog to indicate how many of this hat has been collected.
			var hat_name = collected_hats[hat_scene_file].name
			var modified_hat_dialog = collected_hats[hat_scene_file].dialog
			modified_hat_dialog += " You've collected %s of these bad boys." % collected_hats[hat_scene_file].count
			
			# Connect custom signals for button pressed, focus_entered, and focus_exited.
			new_hat_button_panel.pressed.connect(on_hat_button_panel_pressed.bind(modified_hat_dialog, hat_name, new_hat_button_panel))
			new_hat_button_panel.focus_entered.connect(on_hat_button_panel_focus_entered.bind(new_hat_button_panel))
			new_hat_button_panel.focus_exited.connect(on_hat_button_panel_focus_exited.bind(new_hat_button_panel))
			
			# Render hat model on button panel.
			render_hat_on_panel(hat_scene_file, new_hat_button_panel)
		else:
			# Hat yet to be discovered, render "?" and undiscovered hat dialog.
			var undiscovered_hat_dialog = "You haven't discovered this hat yet. Try exploring and remember to bring me hats!"
			new_hat_button_panel.pressed.connect(on_hat_button_panel_pressed.bind(undiscovered_hat_dialog))
			new_hat_button_panel.text = "?"
		
func on_hat_button_panel_pressed(dialog: String, hat_name: String = "???", hat_button_panel: Button = null):
	if is_instance_valid(hat_button_panel):
		hat_button_panel.grab_focus()
	
	hat_name_label.text = hat_name
	await dialog_say(dialog)

func on_hat_button_panel_focus_entered(hat_button_panel: Button):
	if is_instance_valid(hat_button_panel):
		hat_button_panel.emit_signal("play_hat_rotation_tween")
	
func on_hat_button_panel_focus_exited(hat_button_panel: Button):
	if is_instance_valid(hat_button_panel):
		hat_button_panel.emit_signal("kill_hat_rotation_tween")

func render_hat_on_panel(hat_scene_file: String, hat_button_panel: Button):
	# Instantiate hat scene.
	var hat = load(hat_scene_file).instantiate()
	
	# Set up SubViewport and SubviewportContainer nodes.
	var sub_viewport_container = SubViewportContainer.new()
	var sub_viewport = SubViewport.new()
	sub_viewport.transparent_bg = true
	sub_viewport.own_world_3d = true
	sub_viewport_container.add_child(sub_viewport)
	sub_viewport_container.stretch = true
	sub_viewport_container.size = Vector2i(100, 100)
	
	# Add a camera to SubViewport node.
	var camera = Camera3D.new()
	sub_viewport.add_child(camera)
	sub_viewport.add_child(hat)
	
	# Add DirectionalLight3D node and set light energy and rotation properties.
	var directional_light = DirectionalLight3D.new()
	directional_light.light_energy = 0.75
	directional_light.rotation = Vector3(-45, 45, 0)
	sub_viewport.add_child(directional_light)
	
	# Add SubViewportContainer to hat button panel and set hat properties.
	hat_button_panel.add_child(sub_viewport_container)
	hat.position.z = -2
	hat.process_mode = Node.PROCESS_MODE_DISABLED
	camera.look_at_from_position(Vector3(0, 1, 0), hat.position)
	
	# Set custom signals to be able to emit play / kill rotation tweens when un/focused. 
	hat_button_panel.add_user_signal("play_hat_rotation_tween")
	hat_button_panel.connect("play_hat_rotation_tween", set_hat_rotation_tween.bind(hat, hat_scene_file))
	hat_button_panel.add_user_signal("kill_hat_rotation_tween")
	hat_button_panel.connect("kill_hat_rotation_tween", kill_hat_rotation_tween.bind(hat_scene_file))

func set_hat_rotation_tween(hat_node: Hat, hat_scene_file: String):
	collected_hats[hat_scene_file].tween = create_tween()
	collected_hats[hat_scene_file].tween.set_loops()
	collected_hats[hat_scene_file].tween.tween_property(hat_node, "rotation_degrees", Vector3(0, 360, 0), 5).from(Vector3(0, 0, 0))
	collected_hats[hat_scene_file].tween.play()

func kill_hat_rotation_tween(hat_scene_file: String):
	collected_hats[hat_scene_file].tween.custom_step(INF)
	collected_hats[hat_scene_file].tween.kill()

func _on_close_button_pressed() -> void:
	on_exit_interaction()

func _on_prev_button_pressed() -> void:
	# Note: This is hard coded for now, will need to track pages when we have > 24 hats.
	render_catalog_page(0)
	hat_name_label.text = ""

func _on_next_button_pressed() -> void:
	# Note: This is hard coded for now, will need to track pages when we have > 24 hats.
	render_catalog_page(12)
	hat_name_label.text = ""

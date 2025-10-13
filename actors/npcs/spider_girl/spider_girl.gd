extends Area3D

var player_nearby = false
var player_interacting = false
var player_ref
var camera_original_basis
var camera_original_position_vec
var yarn: int = 0

@onready var dialog_panel: Panel = %DialogPanel
@onready var dialog_label: Label = %DialogLabel
@onready var dialog_button: Button = %DialogButton
@onready var yay: CPUParticles3D = $Yay

@onready var catalog_panel: Panel = %CatalogPanel
@onready var dispense_button: Button = %DispenseButton
@onready var exit_button: Button = %ExitButton
@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2: Marker3D = $Marker3D2

var collected_hats = {
	"res://actors/hats/beefeater/beefeater.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/beret/beret.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/bicorn/bicorn.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/buffalo/buffalo.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/cowboy/cowboy.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/fez/fez.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/jester/jester.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/madder/madder.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/mortarboard/mortarboard.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/phrygian/phrygian.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/scally/scally.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/sombrero/sombrero.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/tricorn/tricorn.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/tyrolean/tyrolean.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
	"res://actors/hats/witch/witch.tscn" = {
		"count": 0,
		"dialog": "Dialogue goes here."
	},
}

#func _ready() -> void:
	#init_hat_catalog_items()

func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("shoot"):
		if not player_interacting:
			on_player_interact(delta)

func on_player_interact(_delta: float):
	player_interacting = true
	on_zoom_camera()
	intro_dialog()
	
	for child in catalog_panel.get_children():
		child.queue_free()
	init_hat_catalog_items()

func on_zoom_camera():
	if is_instance_valid(player_ref):
		player_ref.global_position = marker_3d_2.global_position
		player_ref.model.global_basis = marker_3d_2.global_basis
		var camera_node = player_ref.get_node("Camera3D")
		camera_original_position_vec = camera_node.position
		camera_original_basis = camera_node.basis
		camera_node.global_position = marker_3d.global_position
		camera_node.global_basis = marker_3d.global_basis

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
	catalog_panel.visible = false

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

func init_hat_catalog_items():
	var button_pos_y = -90
	var button_pos_x = 15
	var hat_index = 0
	
	for r in range(3):
		button_pos_y += 105
		button_pos_x = 15
		
		for c in range(5):
			create_hat_catalog_item(Vector2(button_pos_x, button_pos_y), hat_index)
			hat_index += 1
			button_pos_x += 105
	
func create_hat_catalog_item(pos: Vector2, hat_index):
	var item_height = 100
	var item_length = 100
	var new_hat_button_panel = Button.new()
	new_hat_button_panel.set_position(pos)
	new_hat_button_panel.set_size(Vector2(item_length, item_height))
	catalog_panel.add_child(new_hat_button_panel)
	var hat_keys = collected_hats.keys()
	
	if hat_index <= hat_keys.size():
		var hat_scene_file = hat_keys[hat_index]
		
		if collected_hats[hat_scene_file].count > 0:
			new_hat_button_panel.pressed.connect(on_hat_button_panel_pressed.bind(collected_hats[hat_scene_file].dialog))
			render_hat_on_panel(hat_scene_file, new_hat_button_panel)
		else:
			var undiscovered_hat_dialog = "You haven't discovered this hat yet. Try exploring and remember to bring me hats!"
			new_hat_button_panel.pressed.connect(on_hat_button_panel_pressed.bind(undiscovered_hat_dialog))
			new_hat_button_panel.text = "?"
	else:
		var mystery_dialog = "The fact that this panel exists is a mystery."
		new_hat_button_panel.pressed.connect(on_hat_button_panel_pressed.bind(mystery_dialog))
		new_hat_button_panel.text = "?"

func on_hat_button_panel_pressed(dialog: String):
	await dialog_say(dialog)

func render_hat_on_panel(hat_scene_file: String, item_panel: Button):
	var hat = load(hat_scene_file).instantiate()
	var sub_viewport_container = SubViewportContainer.new()
	var sub_viewport = SubViewport.new()
	sub_viewport.transparent_bg = true
	sub_viewport_container.add_child(sub_viewport)
	sub_viewport_container.stretch = true
	sub_viewport_container.size = Vector2i(100, 100)
	sub_viewport.add_child(Camera3D.new())
	sub_viewport.add_child(hat)
	sub_viewport.own_world_3d = true
	var directional_light = DirectionalLight3D.new()
	directional_light.light_energy = 0.75
	directional_light.rotation = Vector3(-45, 45, 0)
	sub_viewport.add_child(directional_light)
	item_panel.add_child(sub_viewport_container)
	hat.position.z = -2
	hat.process_mode = Node.PROCESS_MODE_DISABLED

func _on_exit_button_pressed() -> void:
	on_exit_interaction()

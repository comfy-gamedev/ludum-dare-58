extends Control

@onready var start_game_button: Button = %StartGameButton
@onready var how_to_play_button: Button = %HowToPlayButton
@onready var options_button: Button = %OptionsButton
@onready var animation_player: AnimationPlayer = $Node/Node3D/spider/AnimationPlayer
@onready var arachno_check_button: CheckButton = %ArachnoCheckButton


func _ready() -> void:
	start_game_button.grab_focus()
	MusicMan.music(preload("res://assets/music/soundloop.wav"))
	animation_player.play("Idle")
	arachno_check_button.button_pressed = Settings.a11y_arachnophobia


func _on_start_game_button_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_gameplay/main_gameplay.tscn")


func _on_how_to_play_button_pressed() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	SceneGirl.change_scene("res://scenes/options/options.tscn")


func _on_start_game_button_mouse_entered() -> void:
	start_game_button.grab_focus()


func _on_how_to_play_button_mouse_entered() -> void:
	how_to_play_button.grab_focus()


func _on_options_button_mouse_entered() -> void:
	options_button.grab_focus()


func _on_arachno_check_button_pressed() -> void:
	Settings.a11y_arachnophobia = arachno_check_button.button_pressed


func _on_h_box_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			arachno_check_button.button_pressed = not arachno_check_button.button_pressed
			_on_arachno_check_button_pressed()

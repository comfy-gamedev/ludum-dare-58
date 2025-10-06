extends Node2D


func _on_button_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_menu/main_menu.tscn")


func _on_button_2_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_gameplay/main_gameplay.tscn")

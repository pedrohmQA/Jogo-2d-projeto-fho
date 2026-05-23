extends Control

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/title_screen.tscn")

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/forest.tscn")

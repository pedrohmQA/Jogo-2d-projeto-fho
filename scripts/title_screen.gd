
extends Control

@onready var tutorial_panel = $TutorialPanel

func _ready() -> void:
	tutorial_panel.visible = false
	$AudioStreamPlayer.finished.connect(_on_music_finished)
	$AudioStreamPlayer.play()

func _on_music_finished():
	$AudioStreamPlayer.play()
	
func _process(_delta: float) -> void:
	pass


func _on_start_btn_pressed() -> void:
	tutorial_panel.visible = true


func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://creditos.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	QuestState.clear_checkpoint()
	get_tree().change_scene_to_file("res://scene/forest.tscn")
	

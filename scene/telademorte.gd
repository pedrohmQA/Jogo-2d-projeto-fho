extends Control

@onready var retry_button = $VBoxContainer/reiniciar_btn
@onready var menu_button = $VBoxContainer/quit_btn

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func show_screen() -> void:
	visible = true
	get_tree().paused = true
	retry_button.grab_focus()

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/title_screen.tscn")

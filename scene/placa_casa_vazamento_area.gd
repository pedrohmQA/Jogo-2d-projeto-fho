extends Area2D

var player_in_range := false
var dialog_open := false

@onready var dialog_ui: CanvasLayer = get_tree().current_scene.get_node("DialogUI")
@onready var dialog_label: Label = get_tree().current_scene.get_node("DialogUI/Panel/TextLabel")
@onready var hud: CanvasLayer = get_tree().current_scene.get_node("HUD") # troque se necessário

@export var dialogue_text := "Esta casa está com um cano vazando água, e você precisa achar uma fita para tapá-lo."

func _ready() -> void:
	dialog_ui.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		_close_dialog()

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		_open_dialog()

func _open_dialog() -> void:
	if dialog_open:
		return
	dialog_open = true
	dialog_ui.visible = true
	if is_instance_valid(hud):
		hud.visible = false
	dialog_label.text = dialogue_text

func _close_dialog() -> void:
	dialog_open = false
	dialog_ui.visible = false
	if is_instance_valid(hud):
		hud.visible = true
		
func try_interact():
	# Mostra o diálogo na DialogUI padrão
	var dialog_ui = get_tree().current_scene.get_node("DialogUI")
	if dialog_ui:
		dialog_ui.show_dialog("Esta casa está com um cano vazando água, e você precisa achar uma fita para tapá-lo.")

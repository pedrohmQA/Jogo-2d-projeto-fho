extends Area2D

@export_multiline var message: String = "O rio e a floresta estão poluídos, e isso está afetando a vida dos animais! Rápido, você deve recolher todo o lixo em até 8 minutos"

var player_in_range := false
var dialog_open := false

@onready var dialog_ui: CanvasLayer = get_tree().current_scene.get_node("DialogUI")
@onready var dialog_label: Label = get_tree().current_scene.get_node("DialogUI/Panel/TextLabel")

# opcional: se tiver HUD e quiser esconder (como no npc.gd)
@onready var hud: CanvasLayer = get_tree().current_scene.get_node_or_null("HUD")

func _ready() -> void:
	dialog_ui.visible = false
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		_toggle()

	if dialog_open and Input.is_action_just_pressed("ui_cancel"):
		_close_dialog()

func _on_enter(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_exit(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		_close_dialog()

func _toggle() -> void:
	if dialog_open:
		_close_dialog()
	else:
		_open_dialog()

func _open_dialog() -> void:
	dialog_open = true
	dialog_ui.visible = true
	dialog_label.text = message

	if hud != null:
		hud.visible = false

func _close_dialog() -> void:
	dialog_open = false
	dialog_ui.visible = false

	if hud != null:
		hud.visible = true

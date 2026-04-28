extends Area2D

var player_in_range := false
var dialog_open := false

@onready var dialog_ui: CanvasLayer = get_tree().current_scene.get_node("DialogUI")
@onready var dialog_label: Label = get_tree().current_scene.get_node("DialogUI/Panel/TextLabel")

# Se o node instanciado na cena estiver com nome "hud.tscn", use exatamente isso:
@onready var hud: CanvasLayer = get_tree().current_scene.get_node("Hud_tscn")


func _ready() -> void:
	dialog_ui.visible = false
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)


func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		advance_dialog()


func _on_enter(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_exit(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		_close()


func _open_dialog() -> void:
	if dialog_open:
		return
	dialog_open = true
	dialog_ui.visible = true
	if is_instance_valid(hud):
		hud.visible = false


func _close() -> void:
	dialog_open = false
	dialog_ui.visible = false
	if is_instance_valid(hud):
		hud.visible = true


func advance_dialog() -> void:
	_open_dialog()

	# Já completou
	if QuestState.phase == QuestState.QuestPhase.COMPLETED or QuestState.quest_completed:
		dialog_label.text = "Habitante: Muito obrigado Víturus!"
		return

	# Entrega (tem 1 maçã e 1 moeda)
	if QuestState.can_finish():
		QuestState.deliver_items()
		dialog_label.text = "Habitante: Muito obrigado Víturus!"
		return

	

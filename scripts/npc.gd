extends CharacterBody2D

@onready var dialog_ui: CanvasLayer = $"../DialogUI"
@onready var dialog_label: Label = $"../DialogUI/Panel/TextLabel"
@onready var interact_area: Area2D = $InteractArea

var player_in_range := false
var dialog_open := false

func _ready() -> void:
	dialog_ui.visible = false

	# conecta sinais
	interact_area.body_entered.connect(_on_enter)
	interact_area.body_exited.connect(_on_exit)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		_interact()

func _on_enter(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_exit(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		_close_dialog()

func _interact() -> void:
	if dialog_open:
		_close_dialog()
		return

	dialog_open = true
	dialog_ui.visible = true

	if QuestState.quest_completed:
		dialog_label.text = "Obrigado de novo! Você me ajudou muito."
		return

	if not QuestState.quest_started:
		QuestState.quest_started = true
		dialog_label.text = "Oi... você pode me ajudar?\nTraga 1 maçã e 1 moeda pra mim, por favor."
		return

	if QuestState.can_finish():
		QuestState.quest_completed = true
		dialog_label.text = "Você conseguiu! Muito obrigado pela maçã e pela moeda!"
		return

	var faltando := []
	if not QuestState.has_apple:
		faltando.append("maçã")
	if not QuestState.has_coin:
		faltando.append("moeda")

	dialog_label.text = "Ainda preciso de: " + ", ".join(faltando) + "."

func _close_dialog() -> void:
	dialog_open = false
	dialog_ui.visible = false

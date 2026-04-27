extends Area2D

var player_in_range := false
var dialog_open := false

@onready var dialog_ui: CanvasLayer = get_tree().current_scene.get_node("DialogUI")
@onready var dialog_label: Label = get_tree().current_scene.get_node("DialogUI/Panel/TextLabel")

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

func advance_dialog() -> void:
	if not dialog_open:
		dialog_open = true
		dialog_ui.visible = true

	# 1) Se completou, só agradece
	if QuestState.phase == QuestState.QuestPhase.COMPLETED or QuestState.quest_completed:
		dialog_label.text = "Habitante: Muito obrigado Víturus!"
		return

	# 2) Se tem itens, entrega e completa
	if QuestState.can_finish():
		QuestState.deliver_items()
		dialog_label.text = "Habitante: Muito obrigado Víturus!"
		return

	# 3) INTRO controlada SOMENTE por phase
	if QuestState.phase == QuestState.QuestPhase.NOT_MET:
		QuestState.phase = QuestState.QuestPhase.INTRO_NPC
		dialog_label.text = "Habitante: Olá, eu estou com fome e precisando de dinheiro. Ouvi dizer que nesta floresta há o que preciso, você pode me ajudar?"
		return

	if QuestState.phase == QuestState.QuestPhase.INTRO_NPC:
		QuestState.phase = QuestState.QuestPhase.IN_PROGRESS
		QuestState.quest_started = true
		dialog_label.text = "Víturus: Olá. Claro, pode deixar que eu vou te ajudar agora!"
		return

	# 4) Quest em andamento
	var faltando: Array[String] = []
	if not QuestState.has_apple:
		faltando.append("maçã")
	if not QuestState.has_coin:
		faltando.append("moeda")

	dialog_label.text = "Habitante: Ainda falta: " + ", ".join(faltando) + "."

func _close() -> void:
	dialog_open = false
	dialog_ui.visible = false

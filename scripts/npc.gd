extends CharacterBody2D

var player_in_range := false
var dialog_open := false

# --- Ajuste estes NodePaths se necessário ---
@onready var interact_area: Area2D = $InteractArea
@onready var dialog_ui: CanvasLayer = get_tree().current_scene.get_node("DialogUI")
@onready var dialog_label: Label = get_tree().current_scene.get_node("DialogUI/Panel/TextLabel")

# IMPORTANTE:
# Aqui precisa ser o NOME do NODE do HUD na árvore da cena (não o nome do arquivo).
# Recomendo renomear o node instanciado para "HUD" e usar get_node("HUD").
@onready var hud: CanvasLayer = get_tree().current_scene.get_node("HUD")
# ------------------------------------------


func _ready() -> void:
	dialog_ui.visible = false

	# Sinais vêm do Area2D filho
	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		_interact()

	# opcional: fechar com Esc
	if dialog_open and Input.is_action_just_pressed("ui_cancel"):
		_close_dialog()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		_close_dialog()


func _open_dialog() -> void:
	if dialog_open:
		return
	dialog_open = true
	dialog_ui.visible = true
	if is_instance_valid(hud):
		hud.visible = false


func _close_dialog() -> void:
	dialog_open = false
	dialog_ui.visible = false
	if is_instance_valid(hud):
		hud.visible = true


func _interact() -> void:
	_open_dialog()
	print("DEBUG QUEST:", QuestState.apples, QuestState.coins, QuestState.garbage, QuestState.phase)

	# 1) Quest completa
	if QuestState.phase == QuestState.QuestPhase.COMPLETED or QuestState.quest_completed:
		dialog_label.text = "Habitante: Muito obrigado Víturus!"
		return

	# 2) Se tiver os itens, entrega
	if QuestState.can_finish():
		QuestState.deliver_items()
		dialog_label.text = "Habitante: Muito obrigado Víturus!"
		return

	# 3) Intro (2 falas)
	if QuestState.phase == QuestState.QuestPhase.NOT_MET:
		QuestState.phase = QuestState.QuestPhase.INTRO_NPC
		dialog_label.text = "Habitante: Olá, eu estou com fome e precisando de dinheiro. Ouvi dizer que nesta floresta há o que preciso, você pode me ajudar?"
		return

	if QuestState.phase == QuestState.QuestPhase.INTRO_NPC:
		QuestState.phase = QuestState.QuestPhase.IN_PROGRESS
		QuestState.quest_started = true
		dialog_label.text = "Víturus: Olá. Claro, pode deixar que eu vou te ajudar agora!"
		return

	# 4) Em progresso: mostrar o que falta (CONTADORES)
	var faltando: Array[String] = []
	if QuestState.apples < 1:
		faltando.append("maçã")
	if QuestState.coins < 1:
		faltando.append("moeda")

	if faltando.is_empty():
		dialog_label.text = "Habitante: Pode me entregar, por favor?"
		return

	dialog_label.text = "Habitante: Ainda preciso de: " + ", ".join(faltando) + "."

extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text_intro := "Olá que bom que você está aqui! Preciso que você me traga uma bateria, cabos e uma placa solar para construirmos um painel."
@export var dialogue_text_ready := "Ótimo, vamos construir o painel!"
@export var dialogue_text_incomplete := "Ainda não encontrei minhas folhas..."

var player_in_range := false
var quest_completed := false
var mission_started := false

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		print("DEBUG: Player entrou no range do Professor")

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		print("DEBUG: Player saiu do range do Professor")

func try_interact():
	print("DEBUG: try_interact chamado")
	print("DEBUG: player_in_range =", player_in_range)
	print("DEBUG: quest_completed =", quest_completed)
	print("DEBUG: mission_started =", mission_started)
	print("DEBUG: papers =", QuestState.papers)
	print("DEBUG: professor_quest_completed =", QuestState.professor_quest_completed)

	if not player_in_range:
		print("DEBUG: Nao esta no range, abortando interacao")
		return

	# Se a quest ja foi concluida (local ou global), apenas agradece.
	if quest_completed or QuestState.professor_quest_completed:
		quest_completed = true
		emit_signal("dialogue_requested", dialogue_text_ready)
		return

	# Primeira interacao: missao ainda nao comecou.
	if not mission_started:
		mission_started = true
		QuestState.professor_quest_started = true
		print("DEBUG: Primeira interacao, missao comecou agora")
		emit_signal("dialogue_requested", dialogue_text_intro)
		return

	# Prioriza entrega se o papel ja foi coletado.
	if QuestState.papers >= 1 or QuestState.can_finish_professor():
		print("DEBUG: Quest pode ser finalizada, entregando papel")
		QuestState.deliver_professor_paper()
		emit_signal("dialogue_requested", dialogue_text_ready)
		quest_completed = true
		return

	print("DEBUG: Missao incompleta, faltam papeis")
	emit_signal("dialogue_requested", dialogue_text_incomplete)

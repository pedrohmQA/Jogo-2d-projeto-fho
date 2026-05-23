extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text_intro := "Olá aventureiro! Preciso começar a aula, mas perdi minhas folhas, você pode encontrar e me entregar?"
@export var dialogue_text_ready := "Obrigado pela ajuda!"
@export var dialogue_text_incomplete := "Ainda não encontrei minhas folhas..."

var player_in_range := false
var quest_completed := false
var mission_started := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

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

	if not player_in_range or quest_completed:
		print("DEBUG: Não está no range ou quest já completa, abortando interação")
		return

	# Primeira interação: missão ainda não começou
	if not mission_started:
		mission_started = true
		QuestState.professor_quest_started = true
		print("DEBUG: Primeira interação, missão começou agora")
		emit_signal("dialogue_requested", dialogue_text_intro)
		return

	# Missão pode ser finalizada
	if QuestState.can_finish_professor():
		print("DEBUG: Quest pode ser finalizada, entregando papel")
		QuestState.deliver_professor_paper()
		emit_signal("dialogue_requested", dialogue_text_ready)
		quest_completed = true
	else:
		print("DEBUG: Missão incompleta, faltam papéis")
		emit_signal("dialogue_requested", dialogue_text_incomplete)

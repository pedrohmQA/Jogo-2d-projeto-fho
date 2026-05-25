extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text_intro := "Olá, que bom que você está aqui! Preciso que você me traga uma bateria, cabos e uma placa solar para construirmos um painel."
@export var dialogue_text_ready := "Ótimo! Obrigado pela ajuda!"
@export var dialogue_text_incomplete := "Ainda faltam itens."

var player_in_range := false
var quest_completed := false
var mission_started := false

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		print("DEBUG: Player entrou no range do NPC")

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		print("DEBUG: Player saiu do range do NPC")

func try_interact():
	print("DEBUG: try_interact chamado")
	print("DEBUG: player_in_range =", player_in_range)
	print("DEBUG: quest_completed =", quest_completed)
	print("DEBUG: mission_started =", mission_started)

	if not player_in_range or quest_completed:
		print("DEBUG: Nao esta no range ou quest ja completa, abortando interacao")
		return

	if not mission_started:
		mission_started = true
		print("DEBUG: Primeira interacao, missao comecou agora")
		emit_signal("dialogue_requested", dialogue_text_intro)
		return

	if QuestState.can_finish_grassland():
		print("DEBUG: Quest pode ser finalizada, entregando itens e exibindo painel")
		QuestState.deliver_grassland_items()
		emit_signal("dialogue_requested", dialogue_text_ready)
		quest_completed = true

		var panel = get_tree().root.find_child("SolarPanelBuilt", true, false)
		if panel:
			panel.visible = true
	else:
		print("DEBUG: Missao incompleta, faltam itens")
		emit_signal("dialogue_requested", dialogue_text_incomplete)

extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text_intro := "Olá! Traga uma bateria, um cabo e um painel solar para ajudar a cidade."
@export var dialogue_text_ready := "Ótimo! Obrigada, vou instalar nosso novo painel solar!"
@export var dialogue_text_incomplete := "Ainda faltam itens. Por favor, traga uma bateria, um cabo e um painel solar."

var player_in_range := false
var quest_completed := false
var mission_started := false

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
		print("DEBUG: Não está no range ou quest já completa, abortando interação")
		return

	# Primeira interação: missão ainda não começou
	if not mission_started:
		mission_started = true
		print("DEBUG: Primeira interação, missão começou agora")
		emit_signal("dialogue_requested", dialogue_text_intro)
		return

	# Missão pode ser finalizada
	if QuestState.can_finish_grassland():
		print("DEBUG: Quest pode ser finalizada, entregando itens e exibindo painel")
		QuestState.deliver_grassland_items()
		emit_signal("dialogue_requested", dialogue_text_ready)
		quest_completed = true

		# Exibe painel instalado
		var panel = get_tree().root.find_child("SolarPanelBuilt", true, false)
		if panel:
			panel.visible = true
	else:
		print("DEBUG: Missão incompleta, faltam itens")
		emit_signal("dialogue_requested", dialogue_text_incomplete)

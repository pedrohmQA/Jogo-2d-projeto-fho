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

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false

func try_interact():
	if not player_in_range or quest_completed:
		return

	# PRIMEIRA INTERAÇÃO: missão ainda não começou?
	if not mission_started:
		mission_started = true
		emit_signal("dialogue_requested", dialogue_text_intro)
		return

	# SEGUNDA INTERAÇÃO EM DIANTE:
	if QuestState.can_finish_grassland():
		QuestState.deliver_grassland_items()
		emit_signal("dialogue_requested", dialogue_text_ready)
		quest_completed = true

		# Mostra painel visual construído
		var panel = get_tree().get_root().find_child("SolarPanelBuilt", true, false)
		if panel:
			panel.visible = true
	else:
		emit_signal("dialogue_requested", dialogue_text_incomplete)

# NpcGrassland.gd
extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text := 'Engenheira: Que bom que você está aqui! Esta cidade precisa de energia limpa e renovável. Você precisa achar uma bateria, um cabo e um painel para construirmos um painel de energia solar. Encontre e me entregue esses itens!'

var player_in_range := false
var dialogue_open := false

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false

func try_open_dialogue():
	if player_in_range and not dialogue_open:
		emit_signal("dialogue_requested", dialogue_text)
		dialogue_open = true

func on_dialogue_closed():
	dialogue_open = false

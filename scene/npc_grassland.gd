extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text := 'Engenheira: Que bom que você está aqui!" Esta cidade precisa de energia limpa e renovável. Você precisa achar uma bateria, um cabo e um painel para construirmos um painel de energia solar. Encontre e me entregue esses itens!'

var player_in_range = false

func _on_body_entered(body):
	print("Entrou body: ", body, " Name: ", body.name)
	if body is CharacterBody2D: # pega QUALQUER player do tipo correto
		player_in_range = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		print("E detectado")
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("sinal emitido")
		emit_signal("dialogue_requested", dialogue_text)
		

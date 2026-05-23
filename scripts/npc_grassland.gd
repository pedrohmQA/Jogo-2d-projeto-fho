extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text := 'Engenheira: "Que bom que você está aqui!" Esta cidade precisa de energia limpa e renovável. Você precisa achar uma bateria, um cabo e um painel para construirmos um painel de energia solar.'

var player_in_range = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		emit_signal("dialogue_requested", dialogue_text)

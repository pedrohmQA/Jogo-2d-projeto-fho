extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text := 'Engenheira: "Que bom que você está aqui!" ...'

var player_in_range = false

func _on_body_entered(body):
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	print("Entrou: ", body.name)
	if body.name == "Player":
		player_in_range = true

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("E pressionado perto do NPC!")
		emit_signal("dialogue_requested", dialogue_text)

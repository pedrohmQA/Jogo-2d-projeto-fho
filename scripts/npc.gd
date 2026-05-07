# npc.gd
extends Area2D

signal dialogue_requested(dialogue_text: String)
@export var dialogue_text := "Olá, jogador!"

var player_in_range: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	$AnimatedSprite2D.flip_h = true

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"): # Certifique-se de que "interact" existe no Input Map
		emit_signal("dialogue_requested", dialogue_text)

extends Area2D

signal dialogue_requested(dialogue_text: String)

var player_in_range := false

@export var dialogue_text := "Esta casa está com um cano vazando água, e você precisa achar uma fita para tapá-lo."

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		
func try_interact():
	if player_in_range:
		emit_signal("dialogue_requested", dialogue_text)

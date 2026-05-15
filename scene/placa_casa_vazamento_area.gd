extends Area2D

@export var dialogue_text := "Esta casa está com um cano vazando água, e você precisa achar uma fita para tapá-lo."
var player_in_range := false

func _on_body_entered(body):
	if body.is_in_group("player"):   # Ou if body is CharacterBody2D:
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func try_interact():
	if player_in_range:
		# Vai chamar o DialogUI do NPC, já existente!
		var dialog_ui = get_tree().get_root().find_child("DialogUI", true, false)
		if dialog_ui:
			dialog_ui.show_dialog(dialogue_text)

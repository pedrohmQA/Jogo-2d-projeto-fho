extends Area2D

signal dialogue_requested(dialogue_text: String)
signal pipe_repaired

var player_in_range := false

@export var dialogue_text_no_tape := "Este cano está vazando água! Preciso de uma fita para tapá-lo."
@export var dialogue_text_fixed := "Usei a fita para vedar o cano! O vazamento parou."

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
	if not player_in_range:
		return
	if QuestState.pipe_fixed:
		return
	if QuestState.has_tape:
		QuestState.fix_pipe()
		emit_signal("pipe_repaired")
		emit_signal("dialogue_requested", dialogue_text_fixed)
	else:
		emit_signal("dialogue_requested", dialogue_text_no_tape)

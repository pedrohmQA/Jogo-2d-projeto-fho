extends Node2D

@export var total_garbage: int = 5

func _ready() -> void:
	# Inicializa o contador regressivo ao entrar na fase
	QuestState.start_tropic_garbage(total_garbage)
	print("TROPIC: garbage_left init =", QuestState.garbage_left)

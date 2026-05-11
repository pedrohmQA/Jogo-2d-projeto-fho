extends Node2D

@export var total_garbage: int = 12

func _ready() -> void:
	# Inicializa o contador regressivo ao entrar na fase
	QuestState.start_tropic_garbage(total_garbage)
	print("TROPIC: garbage_left init =", QuestState.garbage_left)
	$LevelEnd.visible = false  # Garante que começa invisível

func on_garbage_collected():
	QuestState.garbage_left -= 1
	print("TROPIC: garbage_left =", QuestState.garbage_left)
	if QuestState.garbage_left <= 0:
		ativar_levelend()

func ativar_levelend():
	$LevelEnd.visible = true
	print("LevelEnd ativado!")

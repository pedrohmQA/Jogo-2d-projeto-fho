extends Node2D

@export var total_garbage: int = 12

func _ready() -> void:
	# Inicializa contador regressivo
	QuestState.start_tropic_garbage(total_garbage)
	print("TROPIC: garbage_left init =", QuestState.garbage_left)
	$LevelEnd.visible = false  # Garante que começa invisível

	# Loop manual para música
	if $AudioStreamPlayer:
		$AudioStreamPlayer.finished.connect(_on_music_finished)
		$AudioStreamPlayer.play()

func _on_music_finished():
	$AudioStreamPlayer.play()

func on_garbage_collected():
	QuestState.garbage_left -= 1
	print("TROPIC: garbage_left =", QuestState.garbage_left)
	if QuestState.garbage_left <= 0:
		ativar_levelend()

func ativar_levelend():
	$LevelEnd.visible = true
	print("LevelEnd ativado!")

extends Node

enum QuestPhase { NOT_MET, INTRO_NPC, IN_PROGRESS, COMPLETED }
var phase: QuestPhase = QuestPhase.NOT_MET

var quest_started := false
var quest_completed := false

# Contadores (HUD)
var apples: int = 0
var coins: int = 0
var garbage: int = 0 # novo coletável: garbage_trash

func can_finish() -> bool:
	# Pode entregar se ainda não completou e tem pelo menos 1 de cada item
	return (not quest_completed) and apples >= 1 and coins >= 1 and garbage >= 1

func deliver_items() -> void:
	# Consome 1 de cada item e completa a quest
	apples = max(0, apples - 1)
	coins = max(0, coins - 1)
	garbage = max(0, garbage - 1)

	quest_started = true
	quest_completed = true
	phase = QuestPhase.COMPLETED

func reset_all() -> void:
	phase = QuestPhase.NOT_MET
	quest_started = false
	quest_completed = false
	apples = 0
	coins = 0
	garbage = 0

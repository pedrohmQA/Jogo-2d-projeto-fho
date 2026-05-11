extends Node
# Singleton (Autoload) para estado do jogo/quests.
# Forest: maçã + moeda (entrega no NPC)
# Tropic: lixo com contador regressivo (começa no total e vai até 0)
signal all_garbage_collected

enum QuestPhase { NOT_MET, INTRO_NPC, IN_PROGRESS, COMPLETED }
var phase: QuestPhase = QuestPhase.NOT_MET

var quest_started := false
var quest_completed := false

# =====================
# FOREST (HUD/quest)
# =====================
var apples: int = 0
var coins: int = 0

func can_finish_forest() -> bool:
	return (not quest_completed) and apples >= 1 and coins >= 1

func deliver_forest_items() -> void:
	apples = max(0, apples - 1)
	coins  = max(0, coins - 1)

	quest_started = true
	quest_completed = true
	phase = QuestPhase.COMPLETED

# Compatibilidade com seu NPC atual (se ele chama can_finish/deliver_items)
func can_finish() -> bool:
	return can_finish_forest()

func deliver_items() -> void:
	deliver_forest_items()

# =====================
# TROPIC (LIXO regressivo)
# =====================
# Quantos lixos faltam coletar na tropic
var garbage_left: int = 0

func start_tropic_garbage(total: int) -> void:
	garbage_left = max(0, total)

func collect_one_garbage():
	garbage_left -= 1
	if garbage_left <= 0:
		garbage_left = 0
		emit_signal("all_garbage_collected")

func is_tropic_garbage_done() -> bool:
	return garbage_left <= 0

# =====================
# RESET
# =====================
func reset_all() -> void:
	phase = QuestPhase.NOT_MET
	quest_started = false
	quest_completed = false
	apples = 0
	coins = 0
	garbage_left = 0

func reset_forest_quest() -> void:
	phase = QuestPhase.NOT_MET
	quest_started = false
	quest_completed = false
	apples = 0
	coins = 0

func reset_tropic_garbage() -> void:
	garbage_left = 0

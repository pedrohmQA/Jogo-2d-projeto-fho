extends Node
# Singleton (Autoload) para estado do jogo/quests.
# Forest: quest de maçã + moeda
# Tropic: coletável lixo separado (não bloqueia a quest da forest)

enum QuestPhase { NOT_MET, INTRO_NPC, IN_PROGRESS, COMPLETED }
var phase: QuestPhase = QuestPhase.NOT_MET

var quest_started := false
var quest_completed := false

# Contadores (HUD / coletáveis)
var apples: int = 0
var coins: int = 0
var garbage: int = 0  # Tropic (não faz parte da entrega do NPC da forest)

# =====================
# FOREST (NPC)
# =====================

func can_finish_forest() -> bool:
	# Só maçã e moeda (forest)
	return (not quest_completed) and apples >= 1 and coins >= 1

func deliver_forest_items() -> void:
	# Consome 1 de cada e completa a quest da forest
	apples = max(0, apples - 1)
	coins  = max(0, coins - 1)

	quest_started = true
	quest_completed = true
	phase = QuestPhase.COMPLETED

# Mantém compatibilidade com seu NPC atual (que chama can_finish/deliver_items)
func can_finish() -> bool:
	return can_finish_forest()

func deliver_items() -> void:
	deliver_forest_items()

# =====================
# TROPIC (LIXO)
# =====================

func add_garbage(amount: int = 1) -> void:
	garbage = max(0, garbage + amount)

func consume_garbage(amount: int = 1) -> void:
	garbage = max(0, garbage - amount)

# =====================
# RESET
# =====================

func reset_all() -> void:
	phase = QuestPhase.NOT_MET
	quest_started = false
	quest_completed = false
	apples = 0
	coins = 0
	garbage = 0

# (Opcional) resetar só a quest da forest sem apagar lixo
func reset_forest_quest() -> void:
	phase = QuestPhase.NOT_MET
	quest_started = false
	quest_completed = false
	apples = 0
	coins = 0

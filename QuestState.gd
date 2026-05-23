extends Node
# Singleton (Autoload) para estado do jogo/quests.
# Forest: maçã + moeda (entrega no NPC)
# Tropic: lixo com contador regressivo (começa no total e vai até 0)
# Grassland: painel solar (panel, battery, cable)
# Winterworld: professor - papel

signal all_garbage_collected
signal all_solar_items_collected

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
# GRASSLAND (Itens do painel solar)
# =====================
var panels: int = 0
var batteries: int = 0
var cables: int = 0
var grassland_solar_completed := false

func collect_one_panel():
	panels += 1
	_check_solar_items_collected()

func collect_one_battery():
	batteries += 1
	_check_solar_items_collected()

func collect_one_cable():
	cables += 1
	_check_solar_items_collected()

func is_solar_panel_ready() -> bool:
	return panels >= 1 and batteries >= 1 and cables >= 1

func _check_solar_items_collected():
	if is_solar_panel_ready():
		emit_signal("all_solar_items_collected")

# =====================
# WINTERWORLD (Professor - Papel)
# =====================
var papers: int = 0
var professor_quest_started := false
var professor_quest_completed := false

func collect_one_paper():
	papers += 1

func can_finish_professor() -> bool:
	return (not professor_quest_completed) and papers >= 1

func deliver_professor_paper() -> void:
	papers = max(0, papers - 1)
	professor_quest_completed = true

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
	panels = 0
	batteries = 0
	cables = 0
	grassland_solar_completed = false
	has_tape = false
	pipe_fixed = false
	papers = 0
	professor_quest_started = false
	professor_quest_completed = false

func reset_forest_quest() -> void:
	phase = QuestPhase.NOT_MET
	quest_started = false
	quest_completed = false
	apples = 0
	coins = 0

func reset_tropic_garbage() -> void:
	garbage_left = 0

func reset_grassland_solar() -> void:
	panels = 0
	batteries = 0
	cables = 0
	grassland_solar_completed = false
	
func can_finish_grassland() -> bool:
	return panels >= 1 and batteries >= 1 and cables >= 1

func deliver_grassland_items() -> void:
	panels = 0
	batteries = 0
	cables = 0
	grassland_solar_completed = true

# =====================
# GRASSLAND (Cano/Fita)
# =====================
var has_tape: bool = false
var pipe_fixed: bool = false

func collect_tape() -> void:
	has_tape = true

func fix_pipe() -> void:
	pipe_fixed = true

func reset_grassland_tape() -> void:
	has_tape = false
	pipe_fixed = false

extends Node

enum QuestPhase { NOT_MET, INTRO_NPC, IN_PROGRESS, COMPLETED }
var phase: QuestPhase = QuestPhase.NOT_MET

var quest_started := false
var quest_completed := false

var has_apple := false
var has_coin := false

func can_finish() -> bool:
	return (not quest_completed) and has_apple and has_coin

func deliver_items() -> void:
	has_apple = false
	has_coin = false
	quest_started = true
	quest_completed = true
	phase = QuestPhase.COMPLETED

func reset_all() -> void:
	phase = QuestPhase.NOT_MET
	quest_started = false
	quest_completed = false
	has_apple = false
	has_coin = false

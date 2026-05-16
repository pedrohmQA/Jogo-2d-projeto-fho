extends Area2D

signal blocked(message: String)

enum EndType { QUEST, GARBAGE, GRASSLAND }
@export var end_type: EndType = EndType.QUEST
@export var next_scene_path: String = "res://scene/grassland.tscn"
@export var required_garbage_type: String = "tropic" # só faz sentido se end_type for GARBAGE
@export var blocked_message_quest := "Bloqueado: entregue a maçã e a moeda ao NPC para passar."
@export var blocked_message_garbage := "Colete todo o lixo desta fase para passar!"
@export var blocked_message_grassland := "Complete as duas missões da grassland para passar."

func _ready() -> void:
	$AnimatedSprite2D.visible = true
	self.visible = true
	$AnimatedSprite2D.play("idle")
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if end_type == EndType.QUEST:
		if QuestState.phase != QuestState.QuestPhase.COMPLETED:
			_emit_blocked(blocked_message_quest)
			return

	elif end_type == EndType.GARBAGE:
		if not _is_garbage_done():
			_emit_blocked(blocked_message_garbage)
			return

	elif end_type == EndType.GRASSLAND:
		if not QuestState.is_grassland_missions_done():
			_emit_blocked(blocked_message_grassland)
			return

	get_tree().change_scene_to_file(next_scene_path)

func _is_garbage_done() -> bool:
	if required_garbage_type == "tropic":
		return QuestState.is_tropic_garbage_done()
	elif required_garbage_type == "forest":
		return QuestState.is_forest_garbage_done()
	return false

func _emit_blocked(message: String) -> void:
	print(message)
	emit_signal("blocked", message)

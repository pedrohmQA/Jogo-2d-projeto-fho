extends Area2D

enum EndType { QUEST, GARBAGE }
@export var end_type: EndType = EndType.QUEST
@export var next_scene_path: String = "res://scene/tropic.tscn"
@export var required_garbage_type: String = "tropic" # só fará sentido se end_type for GARBAGE

func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if end_type == EndType.QUEST:
		if QuestState.phase != QuestState.QuestPhase.COMPLETED:
			print("Bloqueado: entregue a maçã e a moeda ao NPC para passar.")
			return
	
	if end_type == EndType.GARBAGE:
		if not _is_garbage_done():
			print("Colete todo o lixo desta fase para passar!")
			return

	get_tree().change_scene_to_file(next_scene_path)

func _is_garbage_done() -> bool:
	if required_garbage_type == "tropic":
		return QuestState.is_tropic_garbage_done()
	elif required_garbage_type == "forest":
		return QuestState.is_forest_garbage_done()
	return false

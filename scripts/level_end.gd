extends Area2D

@export var next_scene_path: String = "res://scene/tropic.tscn"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	# TRAVA TOTAL: só passa se a quest estiver COMPLETED
	if QuestState.phase != QuestState.QuestPhase.COMPLETED:
		print("Bloqueado: entregue a maçã e a moeda ao NPC.")
		return

	get_tree().change_scene_to_file(next_scene_path)

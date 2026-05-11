extends Area2D

enum EndType { QUEST, GARBAGE }
@export var end_type: EndType = EndType.QUEST
@export var next_scene_path: String = "res://scene/grassland.tscn"
@export var required_garbage_type: String = "tropic" # só faz sentido se end_type for GARBAGE

func _ready() -> void:
	print("LevelEnd pronto!", self)
	$AnimatedSprite2D.visible = true
	self.visible = true
	$AnimatedSprite2D.play("idle")
	body_entered.connect(_on_body_entered)
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.visible = true
	self.visible = true
	print("LevelEnd pronto!", self)
	body_entered.connect(_on_body_entered)
	print("LevelEnd posição:", global_position, "AnimSprite visível?", $AnimatedSprite2D.visible, "Z:", $AnimatedSprite2D.z_index)

func _on_body_entered(body: Node2D) -> void:
	print("Bandeira: colisão detectada com", body)
	print("DEBUG bandeira: entrou!", body, "grupos:", body.get_groups())
	if not body.is_in_group("player"):
		print("Não é player, ignorando")
		return

	print("[DEBUG] end_type:", end_type)
	if end_type == EndType.QUEST:
		print("[DEBUG] phase atual:", QuestState.phase, "esperado COMPLETED:", QuestState.QuestPhase.COMPLETED)
		if QuestState.phase != QuestState.QuestPhase.COMPLETED:
			print("Bloqueado: entregue a maçã e a moeda ao NPC para passar.")
			return

	if end_type == EndType.GARBAGE:
		var result = _is_garbage_done()
		print("[DEBUG] GARBAGE done?", result, "(required_garbage_type:", required_garbage_type, ")")
		if not result:
			print("Colete todo o lixo desta fase para passar!")
			return

	print("[DEBUG] Trocando de cena para:", next_scene_path)
	get_tree().change_scene_to_file(next_scene_path)

func _is_garbage_done() -> bool:
	if required_garbage_type == "tropic":
		return QuestState.is_tropic_garbage_done()
	elif required_garbage_type == "forest":
		return QuestState.is_forest_garbage_done()
	return false

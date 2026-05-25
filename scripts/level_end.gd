extends Area2D

enum EndType { QUEST, GARBAGE, GRASSLAND, ALWAYS }
@export var end_type: EndType = EndType.QUEST
@export var next_scene_path: String = "res://scene/grassland.tscn"
@export var required_garbage_type: String = "tropic" # so faz sentido se end_type for GARBAGE
@export var start_hidden: bool = false

func _ready() -> void:
	_set_active(not start_hidden)
	$AnimatedSprite2D.play("idle")
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	print("LevelEnd pronto!", self, "posicao:", global_position, "visivel:", visible)

func _on_body_entered(body: Node2D) -> void:
	print("Bandeira: colisao detectada com", body)
	if not body.is_in_group("player"):
		print("Nao e player, ignorando")
		return

	if end_type == EndType.QUEST:
		if QuestState.phase != QuestState.QuestPhase.COMPLETED:
			print("Bloqueado: entregue a maca e a moeda ao NPC para passar.")
			return

	if end_type == EndType.GARBAGE:
		if not _is_garbage_done():
			print("Colete todo o lixo desta fase para passar!")
			return

	if end_type == EndType.GRASSLAND:
		var grassland_ready := QuestState.grassland_solar_completed and QuestState.pipe_fixed
		if not grassland_ready:
			print("Complete as missoes do painel solar e do cano para passar.")
			return

	print("Trocando de cena para:", next_scene_path)
	get_tree().change_scene_to_file(next_scene_path)

func _is_garbage_done() -> bool:
	if required_garbage_type == "tropic":
		return QuestState.is_tropic_garbage_done()
	elif required_garbage_type == "forest":
		return QuestState.is_forest_garbage_done()
	return false

func _set_active(active: bool) -> void:
	visible = active
	$AnimatedSprite2D.visible = active
	var collision := $CollisionShape2D as CollisionShape2D
	if collision:
		collision.disabled = not active

extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text_request := "os habitantes da cidade precisam de uma ponte para passar por este buraco, encontre madeira e venha construir a ponte"
@export var dialogue_text_built := "Perfeito! A ponte foi construida."
@export var bridge_node_path: NodePath = ^"../BridgeBuilt"
@export var level_end_node_path: NodePath = ^"../LevelEndVictory"

var player_in_range := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_sync_progress_visuals()

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D:
		player_in_range = false

func try_interact() -> void:
	if not player_in_range:
		return

	if QuestState.bridge_built:
		emit_signal("dialogue_requested", dialogue_text_built)
		return

	if QuestState.can_build_bridge():
		QuestState.build_bridge()
		_show_bridge(true)
		_set_level_end_active(true)
		emit_signal("dialogue_requested", dialogue_text_built)
		return

	emit_signal("dialogue_requested", dialogue_text_request)

func _show_bridge(built: bool = true) -> void:
	var bridge := get_node_or_null(bridge_node_path)
	if bridge == null:
		return

	if bridge.has_method("set_built"):
		bridge.call("set_built", built)
		return

	var bridge_visual := bridge.get_node_or_null("BridgeVisual") as CanvasItem
	if bridge_visual != null:
		bridge_visual.visible = built

	var collision := bridge.get_node_or_null("BridgeCollision/CollisionShape2D") as CollisionShape2D
	if collision != null:
		collision.disabled = not built

func _sync_progress_visuals() -> void:
	_show_bridge(QuestState.bridge_built)
	_set_level_end_active(QuestState.bridge_built)

func _set_level_end_active(active: bool) -> void:
	var level_end := get_node_or_null(level_end_node_path)
	if level_end == null:
		return

	if level_end is CanvasItem:
		(level_end as CanvasItem).visible = active

	var sprite := level_end.get_node_or_null("AnimatedSprite2D") as CanvasItem
	if sprite != null:
		sprite.visible = active

	var collision := level_end.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision != null:
		collision.disabled = not active

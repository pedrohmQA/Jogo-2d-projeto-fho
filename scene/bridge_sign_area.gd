extends Area2D

signal dialogue_requested(dialogue_text: String)

@export var dialogue_text_request := "Os habitantes da cidade precisam de uma ponte para passar por este buraco, encontre madeira e venha construir a ponte."
@export var dialogue_text_built := "Perfeito! A ponte foi construida."
@export var bridge_node_path: NodePath = ^"../BridgeBuilt"

var player_in_range := false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

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
		_show_bridge()
		emit_signal("dialogue_requested", dialogue_text_built)
		return

	emit_signal("dialogue_requested", dialogue_text_request)

func _show_bridge() -> void:
	var bridge := get_node_or_null(bridge_node_path)
	if bridge == null:
		return

	if bridge.has_method("set_built"):
		bridge.call("set_built", true)
	else:
		var bridge_visual := bridge.get_node_or_null("BridgeVisual")
		if bridge_visual:
			bridge_visual.visible = true
		var collision := bridge.get_node_or_null("BridgeCollision/CollisionShape2D") as CollisionShape2D
		if collision:
			collision.disabled = false

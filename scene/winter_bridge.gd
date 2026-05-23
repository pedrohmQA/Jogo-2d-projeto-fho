extends Node2D

@onready var bridge_visual: CanvasItem = get_node_or_null("BridgeVisual")
@onready var bridge_collision: CollisionShape2D = get_node_or_null("BridgeCollision/CollisionShape2D")

func _ready() -> void:
	set_built(QuestState.bridge_built)

func set_built(built: bool) -> void:
	if bridge_visual != null:
		bridge_visual.visible = built

	if bridge_collision != null:
		bridge_collision.disabled = not built

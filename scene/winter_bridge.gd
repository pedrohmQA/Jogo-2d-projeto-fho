extends Node2D

@onready var bridge_visual := $BridgeVisual
@onready var bridge_collision := $BridgeCollision/CollisionShape2D as CollisionShape2D

func _ready() -> void:
	set_built(QuestState.bridge_built)

func set_built(built: bool) -> void:
	bridge_visual.visible = built
	bridge_collision.disabled = not built

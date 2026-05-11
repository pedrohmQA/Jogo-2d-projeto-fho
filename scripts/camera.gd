extends Camera2D

@export var limit_bottom_normal: int = 208
@export var limit_bottom_in_water: int = 320

var target: Node2D

func _ready() -> void:
	get_target()
	limit_bottom = limit_bottom_normal

func _process(_delta: float) -> void:
	if target == null:
		return

	position = target.position

	# Ajusta limite só quando estiver na água (sem quebrar o resto do cenário)
	if "in_water" in target and target.in_water:
		limit_bottom = limit_bottom_in_water
	else:
		limit_bottom = limit_bottom_normal

func get_target() -> void:
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Player nao encontrado")
		return

	target = nodes[0]

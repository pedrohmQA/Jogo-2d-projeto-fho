extends Area2D

@export var activate_once: bool = false
@export var respawn_point_path: NodePath = ^"RespawnPoint"
@export var saved_text: String = "SALVO"

@onready var respawn_point: Marker2D = get_node(respawn_point_path)
@onready var sign: Node2D = $Sign
@onready var board: Polygon2D = $Sign/Board
@onready var label: Label = $Sign/Label

var activated := false

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if activate_once and activated:
		return
	if not is_player(body):
		return

	activated = true
	var checkpoint_position := respawn_point.global_position
	var scene_path := get_tree().current_scene.scene_file_path

	QuestState.set_checkpoint(scene_path, checkpoint_position)
	body.set("respawn_position", checkpoint_position)

	show_activated_feedback()

func show_activated_feedback() -> void:
	board.color = Color(0.18, 0.95, 0.36, 1.0)
	label.text = saved_text

	var tween := create_tween()
	tween.tween_property(sign, "scale", Vector2(1.12, 1.12), 0.08)
	tween.tween_property(sign, "scale", Vector2.ONE, 0.12)

func is_player(body: Node) -> bool:
	return body.is_in_group("player") or body.is_in_group("Player") or body.has_method("respawn")

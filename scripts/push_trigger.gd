extends Area2D

@export var push_velocity: Vector2 = Vector2(-220, -180)
@export var one_shot: bool = true
@export var cooldown: float = 0.5

var can_trigger := true

func _ready() -> void:
	visible = false

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not can_trigger or not is_player(body):
		return

	print("DEBUG push trigger ativado")
	apply_push(body)

	if one_shot:
		can_trigger = false
		set_deferred("monitoring", false)
		return

	can_trigger = false
	await get_tree().create_timer(cooldown).timeout
	can_trigger = true

func apply_push(body: Node) -> void:
	if body is CharacterBody2D:
		body.velocity = push_velocity

func is_player(body: Node) -> bool:
	return body.is_in_group("player") or body.is_in_group("Player") or body.has_method("respawn")

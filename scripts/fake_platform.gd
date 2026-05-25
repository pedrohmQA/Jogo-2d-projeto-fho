extends Node2D

@export var fall_delay: float = 0.25
@export var respawns: bool = true
@export var respawn_delay: float = 2.0
@export var shake_distance: float = 1.0

@onready var platform: AnimatableBody2D = $Platform
@onready var sprite: Sprite2D = $Platform/Sprite2D
@onready var platform_collision: CollisionShape2D = $Platform/CollisionShape2D
@onready var step_detector: Area2D = $StepDetector
@onready var step_detector_collision: CollisionShape2D = $StepDetector/CollisionShape2D

var triggered := false
var start_position := Vector2.ZERO

func _ready() -> void:
	start_position = platform.position

	if not step_detector.body_entered.is_connected(_on_step_detector_body_entered):
		step_detector.body_entered.connect(_on_step_detector_body_entered)

func _physics_process(_delta: float) -> void:
	if triggered:
		return

	for body in step_detector.get_overlapping_bodies():
		if is_player(body):
			trigger_platform()
			return

func _on_step_detector_body_entered(body: Node) -> void:
	if triggered or not is_player(body):
		return

	trigger_platform()

func trigger_platform() -> void:
	triggered = true
	print("DEBUG fake platform ativada")
	await shake()
	await get_tree().create_timer(fall_delay).timeout
	set_platform_active(false)

	if respawns:
		await get_tree().create_timer(respawn_delay).timeout
		platform.position = start_position
		set_platform_active(true)
		triggered = false

func shake() -> void:
	if shake_distance <= 0:
		return

	var tween := create_tween()
	tween.tween_property(platform, "position", start_position + Vector2(shake_distance, 0), 0.04)
	tween.tween_property(platform, "position", start_position + Vector2(-shake_distance, 0), 0.04)
	tween.tween_property(platform, "position", start_position, 0.04)
	await tween.finished

func set_platform_active(active: bool) -> void:
	platform.visible = active
	platform_collision.set_deferred("disabled", not active)
	step_detector_collision.set_deferred("disabled", not active)

func is_player(body: Node) -> bool:
	return body.is_in_group("player") or body.is_in_group("Player") or body.has_method("respawn")

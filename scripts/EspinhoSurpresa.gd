extends Area2D

@export var reveal_distance: float = 8.0
@export var death_delay: float = 0.45
@export var flash_strength: float = 0.35
var revealed = false
var death_triggered = false
var player_ref = null

func _ready():
	visible = true
	if has_node("Sprite2D"):
		$Sprite2D.visible = false

	player_ref = get_tree().current_scene.find_child("Player", true, false)

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	print("DEBUG espinho pronto")

func _physics_process(_delta):
	if not revealed and player_ref:
		if global_position.distance_to(player_ref.global_position) < reveal_distance:
			reveal()

	if revealed:
		for body in get_overlapping_bodies():
			if is_player(body):
				hit_player(body)
				return

func reveal():
	if revealed:
		return

	revealed = true
	if has_node("Sprite2D"):
		$Sprite2D.visible = true
	print("DEBUG espinho revelou")

func _on_body_entered(body):
	print("DEBUG entrou algo:", body.name)

	if not is_player(body):
		return

	if not revealed:
		reveal()

	hit_player(body)

func is_player(body) -> bool:
	return body.has_method("respawn")

func hit_player(body) -> void:
	if death_triggered:
		return

	death_triggered = true
	print("DEBUG player tocou no espinho")

	if body.has_method("die"):
		freeze_player(body)

	show_death_flash()

	if death_delay > 0:
		await get_tree().create_timer(death_delay).timeout

	if not is_instance_valid(body):
		return

	if body.has_method("die"):
		body.die()
	elif body.has_method("respawn"):
		body.respawn()

func freeze_player(body) -> void:
	if body is CharacterBody2D:
		body.velocity = Vector2.ZERO
	body.set_physics_process(false)

func show_death_flash() -> void:
	var current_scene := get_tree().current_scene
	if current_scene == null:
		return

	var layer := CanvasLayer.new()
	layer.layer = 900
	current_scene.add_child(layer)

	var flash := ColorRect.new()
	flash.color = Color(1, 0, 0, 0)
	flash.anchor_right = 1.0
	flash.anchor_bottom = 1.0
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(flash)

	var tween := create_tween()
	tween.tween_property(flash, "color", Color(1, 0, 0, flash_strength), 0.08)
	tween.tween_property(flash, "color", Color(1, 0, 0, 0), 0.25)
	tween.finished.connect(Callable(layer, "queue_free"))

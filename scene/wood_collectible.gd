extends Area2D

@export var wood_texture_path := "res://sprites/wood_5.png"
@export var fallback_texture_path := "res://sprites/paper.png"

@onready var sprite := $Sprite2D as Sprite2D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	_load_texture()

func _on_body_entered(body: Node) -> void:
	if not _is_player_body(body):
		return

	QuestState.collect_one_wood()
	SoundManager.play_pickup_sound()
	queue_free()

func _is_player_body(body: Node) -> bool:
	return body.is_in_group("player") or body.is_in_group("Player")

func _load_texture() -> void:
	var texture := load(wood_texture_path) as Texture2D
	if texture == null:
		texture = load(fallback_texture_path) as Texture2D
	if texture != null:
		sprite.texture = texture

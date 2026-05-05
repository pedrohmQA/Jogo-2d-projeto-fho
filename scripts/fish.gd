extends Node2D

@export var fish_texture: Texture2D
@export var speed: float = 40.0
@export var direction: float = 1.0
@export var min_x: float = 240.0
@export var max_x: float = 680.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if fish_texture != null:
		sprite.texture = fish_texture

func _process(delta: float) -> void:
	position.x += direction * speed * delta

	if position.x >= max_x:
		direction = -1.0
	elif position.x <= min_x:
		direction = 1.0

	sprite.flip_h = direction < 0.0

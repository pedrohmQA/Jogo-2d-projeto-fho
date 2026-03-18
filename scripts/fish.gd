extends Node2D

# Exported variable for the fish texture
@export var fish_texture: Texture2D

# Movement parameters
var speed: float = 200.0
var direction: int = 0 # -1 for left, 1 for right
var min_x: float = -100.0
var max_x: float = 100.0

func _ready() -> void:
    # Assign texture if set
    if fish_texture:
        $Sprite2D.texture = fish_texture

func _process(delta: float) -> void:
    # Update position based on direction
    position.x += speed * direction * delta
    # Keep position within min_x and max_x
    position.x = clamp(position.x, min_x, max_x)
    # Flip sprite based on direction
    $Sprite2D.flip_h = direction == -1
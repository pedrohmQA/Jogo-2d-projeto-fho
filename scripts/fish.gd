extends Node

@export var fish_texture : Texture2D  # Add this line to export the texture

# Added horizontal bounds
@onready var left_bound = -50 # example value
@onready var right_bound = 50 # example value

func _process(delta):
    var position = self.position
    # Add logic to enforce bounds
    if position.x < left_bound:
        position.x = left_bound
    elif position.x > right_bound:
        position.x = right_bound
    self.position = position
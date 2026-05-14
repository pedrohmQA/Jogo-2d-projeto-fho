extends Node2D

@onready var npc         = $NpcGrassland
@onready var dialog_ui   = $DialogUI

func _ready():
	npc.connect("dialogue_requested", Callable(self, "_on_dialogue_requested"))

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		npc.try_interact()

func _on_dialogue_requested(text):
	dialog_ui.show_dialog(text)

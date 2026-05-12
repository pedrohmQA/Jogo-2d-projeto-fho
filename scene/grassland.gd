# Grassland.gd
extends Node2D  # ou o tipo da sua cena

@onready var npc        = $NpcGrassland
@onready var dialog_ui  = $DialogUI

func _ready():
	# Quando o NPC pedir para abrir diálogo
	npc.connect("dialogue_requested", Callable(self, "_on_dialogue_requested"))
	# Quando o diálogo for fechado, avisa o NPC
	dialog_ui.connect("dialogue_closed", Callable(npc, "on_dialogue_closed"))

func _process(_delta):
	# Aqui o "E" só dispara para abrir diálogo, se for possível
	if Input.is_action_just_pressed("interact"):
		npc.try_open_dialogue()

func _on_dialogue_requested(text):
	dialog_ui.show_dialog(text)

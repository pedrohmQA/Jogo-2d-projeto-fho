extends Node2D

@onready var npc        = $NpcGrassland
@onready var dialog_ui  = $DialogUI
@onready var placa_area = $PlacaCasaVazamentoArea

func _ready():
	npc.connect("dialogue_requested", Callable(self, "_on_dialogue_requested"))
	placa_area.connect("dialogue_requested", Callable(self, "_on_placa_dialogue_requested"))

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		# Prioridade: NPC > Placa
		if npc.player_in_range:
			npc.try_interact()
		elif placa_area.player_in_range:
			placa_area.try_interact()

func _on_dialogue_requested(text):
	dialog_ui.show_dialog(text)

func _on_placa_dialogue_requested(text):
	dialog_ui.show_dialog(text)

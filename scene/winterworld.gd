extends Node2D

@onready var npc = $NpcProfessor
@onready var dialog_ui = $DialogUI
@onready var player = $Tiles/Player

var dialogue_open := false

func _ready():
	npc.connect("dialogue_requested", Callable(self, "_on_dialogue_requested"))
	dialog_ui.connect("dialogue_closed", Callable(self, "_on_dialogue_closed"))
	_set_dialogue_active(false)

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if dialogue_open:
			dialog_ui.hide_dialog()
			return

		# Interação com NPC
		if npc.player_in_range:
			npc.try_interact()

func _on_dialogue_requested(text):
	if dialogue_open:
		return

	_set_dialogue_active(true)
	dialog_ui.show_dialog(text)

func _on_dialogue_closed():
	_set_dialogue_active(false)

func _set_dialogue_active(active: bool):
	dialogue_open = active
	player.set_physics_process(not active)

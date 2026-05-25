extends Node2D

@onready var npc = $NpcProfessor
@onready var bridge_sign = $BridgeSign
@onready var dialog_ui = $DialogUI
@onready var player = $Tiles/Player

var dialogue_open := false

func _ready():
	npc.connect("dialogue_requested", Callable(self, "_on_dialogue_requested"))
	bridge_sign.connect("dialogue_requested", Callable(self, "_on_dialogue_requested"))
	dialog_ui.connect("dialogue_closed", Callable(self, "_on_dialogue_closed"))
	_set_dialogue_active(false)
	
	# Loop manual para música
	if $AudioStreamPlayer:
		$AudioStreamPlayer.finished.connect(_on_music_finished)
		$AudioStreamPlayer.play()

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if dialogue_open:
			dialog_ui.hide_dialog()
			return

		# Interacao com NPC
		if npc.player_in_range:
			npc.try_interact()
			return

		# Interacao com a placa da ponte
		if bridge_sign.player_in_range:
			bridge_sign.try_interact()

func _on_dialogue_requested(text):
	if dialogue_open:
		return

	_set_dialogue_active(true)
	dialog_ui.show_dialog(text)

func _on_music_finished():
	$AudioStreamPlayer.play()

func _on_dialogue_closed():
	_set_dialogue_active(false)

func _set_dialogue_active(active: bool):
	dialogue_open = active
	player.set_physics_process(not active)

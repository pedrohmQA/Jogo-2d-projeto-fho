extends Node2D

@onready var npc        = $NpcGrassland
@onready var dialog_ui  = $DialogUI
@onready var placa_area = $PlacaCasaVazamentoArea
@onready var grassland_hud = $GrasslandHud
@onready var player = $Player
@onready var water_animated = $AnimatedSprite2D

var dialogue_open := false

func _ready():
	npc.connect("dialogue_requested", Callable(self, "_on_dialogue_requested"))
	placa_area.connect("dialogue_requested", Callable(self, "_on_dialogue_requested"))
	placa_area.connect("pipe_repaired", Callable(self, "_on_pipe_repaired"))
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

		# Prioridade: NPC > Placa
		if npc.player_in_range:
			npc.try_interact()
		elif placa_area.player_in_range:
			placa_area.try_interact()

func _on_dialogue_requested(text):
	if dialogue_open:
		return

	_set_dialogue_active(true)
	dialog_ui.show_dialog(text)

func _on_dialogue_closed():
	_set_dialogue_active(false)

func _on_music_finished():
	$AudioStreamPlayer.play()

func _on_pipe_repaired():
	if is_instance_valid(water_animated):
		water_animated.visible = false

func _set_dialogue_active(active: bool):
	dialogue_open = active
	grassland_hud.visible = not active
	player.set_physics_process(not active)

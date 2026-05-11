extends Node2D # ou o Node do seu root

var dialog_open = false

func _ready():
	print("Ready do root rodou!")
	$NpcGrassland.connect("dialogue_requested", Callable(self, "show_dialog"))
	# Inverter lado do sprite do NPC
	$NpcGrassland/AnimatedSprite2D.flip_h = true  # Inverte na horizontal

func _process(delta):
	if dialog_open and Input.is_action_just_pressed("interact"):
		hide_dialog()

func show_dialog(text):
	print("Chamou show_dialog! Texto:", text)
	$DialogUI/Panel.visible = true
	$DialogUI/Panel/TextLabel.text = text
	dialog_open = true

func hide_dialog():
	$DialogUI/Panel.visible = false
	dialog_open = false

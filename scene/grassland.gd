extends Node2D

func _ready():
	$HUD/DialoguePanel.visible = false
	$NpcGrassland.connect("dialogue_requested", Callable($HUD, "show_dialogue"))

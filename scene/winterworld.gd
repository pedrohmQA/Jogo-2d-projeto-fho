extends Node2D

func _ready():
	var player = get_tree().current_scene.find_child("Player", true, false)
	for espinho in get_tree().get_nodes_in_group("EspinhoSurpresa"):
		espinho.set_player(player)

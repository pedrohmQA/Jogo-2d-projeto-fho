extends Node2D
class_name Level

const _DIALOG_SCREEN: PackedScene = preload("res://dialog/dialog_screen.tscn")
var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://sprites/teste.png",
		"dialog": "Olá amigo, você precisa de ajuda?",
		"title": "Víturus"
	},
	1: {
		"faceset": "res://sprites/Idle_Poses (32 x 32).png",
		"dialog": "Teste1",
		"title": "Habitante"
	},
	2: {
		"faceset": "res://sprites/teste.png",
		"dialog": "Teste2",
		"title": "Víturus"
	},
	3: {
		"faceset": "res://sprites/Idle_Poses (32 x 32).png",
		"dialog": "Teste3",
		"title": "Habitante"
	},
	4: {
		"faceset": "res://sprites/teste.png",
		"dialog": "Teste4",
		"title": "Víturus"
	}
}

@export_category("Objects")
@export var _hud: CanvasLayer = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
		_new_dialog.data = _dialog_data
		_hud.add_child(_new_dialog)

extends Control

@onready var lista_creditos = $PanelContainer/Control/VBoxContainer

var velocidade := 18.0
var inicio_y := 125.0
var fim_y := -230.0

func _ready():
	lista_creditos.position.y = inicio_y

func _process(delta):
	lista_creditos.position.y -= velocidade * delta

	if lista_creditos.position.y < fim_y:
		lista_creditos.position.y = inicio_y

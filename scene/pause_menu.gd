extends CanvasLayer

func _ready() -> void:
	print("PauseMenu READY - estou na cena:", get_path())
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		print("Alguma tecla/botão pressionado")
	
	# Teste 2: ação do InputMap
	if Input.is_action_just_pressed("pause"):
		print("Ação pause detectada")
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

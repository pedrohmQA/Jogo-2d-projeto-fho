extends CanvasLayer

signal dialogue_closed

func show_dialog(text):
	print("DEBUG: show_dialog chamado com:", text)
	$Panel.visible = true
	$Panel/TextLabel.text = text   # <-- CORRIGIDO AQUI!
	
	var hud = get_tree().get_root().find_child("grassland_HUD", true, false) # troque se necessário
	if hud:
		hud.visible = false

func hide_dialog():
	$Panel.visible = false

	var hud = get_tree().get_root().find_child("grassland_HUD", true, false)
	if hud:
		hud.visible = true
	emit_signal("dialogue_closed")

func _input(event):
	if $Panel.visible and event.is_action_pressed("interact"):
		hide_dialog()

extends CanvasLayer

func show_dialog(text):
	$DialogUI/Panel.visible = true
	$DialogUI/Panel/TextLabel.text = text

func hide_dialog():
	$DialogUI/Panel.visible = false

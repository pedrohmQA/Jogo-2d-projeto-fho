extends CanvasLayer

signal dialogue_closed

func _ready():
	$Panel.visible = false

func show_dialog(text):
	$Panel.visible = true
	$Panel/TextLabel.text = text

func hide_dialog():
	$Panel.visible = false
	emit_signal("dialogue_closed")

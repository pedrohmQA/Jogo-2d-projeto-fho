extends CanvasLayer

func show_dialogue(text: String):
	$DialoguePanel.visible = true
	$DialoguePanel/DialogueLabel.text = text

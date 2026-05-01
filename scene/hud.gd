extends CanvasLayer

@onready var garbage_label: Label = $TopRight/MarginContainer/Counters/GarbageCounter/GarbageLabel

func _process(_delta: float) -> void:
	garbage_label.text = "x" + str(QuestState.garbage_left)

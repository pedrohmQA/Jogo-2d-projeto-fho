extends CanvasLayer

@onready var apple_label := get_node_or_null("TopRight/MarginContainer/Counters/AppleLabel") as Label
@onready var coin_label := get_node_or_null("TopRight/MarginContainer/Counters/CoinLabel") as Label
@onready var garbage_label := get_node_or_null("TopRight/MarginContainer/Counters/GarbageCounter/GarbageLabel") as Label

func _process(_delta: float) -> void:
	if apple_label != null:
		apple_label.text = "x" + str(QuestState.apples)
	if coin_label != null:
		coin_label.text = "x" + str(QuestState.coins)
	if garbage_label != null:
		garbage_label.text = "x" + str(QuestState.garbage_left)

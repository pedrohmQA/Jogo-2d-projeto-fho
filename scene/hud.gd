extends CanvasLayer

@onready var apple_label: Label = $TopRight/MarginContainer/Counters/AppleLabel
@onready var coin_label: Label = $TopRight/MarginContainer/Counters/CoinLabel

func _process(_delta: float) -> void:
	apple_label.text = "x" + str(QuestState.apples)
	coin_label.text  = "x" + str(QuestState.coins)

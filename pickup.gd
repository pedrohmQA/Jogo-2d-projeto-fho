extends Area2D

enum PickupType { APPLE, COIN, GARBAGE, BATERY, CABLE, PANEL, TAPE }
@export var pickup_type: PickupType = PickupType.APPLE

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	match pickup_type:
		PickupType.APPLE:
			QuestState.apples += 1
		PickupType.COIN:
			QuestState.coins += 1
		PickupType.GARBAGE:
			QuestState.collect_one_garbage()
		PickupType.BATERY:
			QuestState.collect_one_battery()
		PickupType.CABLE:
			QuestState.collect_one_cable()
		PickupType.PANEL:
			QuestState.collect_one_panel()
		PickupType.TAPE:
			QuestState.collect_tape()

	SoundManager.play_pickup_sound()
	queue_free()

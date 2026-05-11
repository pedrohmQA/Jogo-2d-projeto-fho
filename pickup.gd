extends Area2D

enum PickupType { APPLE, COIN, GARBAGE }
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

	SoundManager.play_pickup_sound()
	queue_free()

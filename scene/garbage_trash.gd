extends Area2D

enum PickupType { APPLE, COIN, GARBAGE }
@export var pickup_type: PickupType = PickupType.APPLE

var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if not body.is_in_group("player"):
		return

	collected = true

	match pickup_type:
		PickupType.APPLE:
			QuestState.apples += 1
			print("PICKED APPLE: ", QuestState.apples)
		PickupType.COIN:
			QuestState.coins += 1
			print("PICKED COIN: ", QuestState.coins)
		PickupType.GARBAGE:
			QuestState.garbage += 1
			print("PICKED GARBAGE: ", QuestState.garbage)

	monitoring = false
	set_deferred("monitorable", false)
	queue_free()

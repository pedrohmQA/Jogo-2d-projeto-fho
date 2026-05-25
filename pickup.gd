extends Area2D

enum PickupType { APPLE, COIN, GARBAGE, BATERY, CABLE, PANEL, TAPE, PAPER }
@export var pickup_type: PickupType = PickupType.APPLE

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Compatibilidade entre cenas que usam "player" e outras que usam "Player".
	if not _is_player_body(body):
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
		PickupType.PAPER:
			QuestState.collect_one_paper()

	SoundManager.play_pickup_sound()
	queue_free()

func _is_player_body(body: Node) -> bool:
	return body.is_in_group("player") or body.is_in_group("Player")

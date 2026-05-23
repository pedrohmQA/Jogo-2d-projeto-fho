extends Area2D

var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if not body.is_in_group("player"):
		return

	collected = true
	QuestState.has_coin = true

	monitoring = false
	set_deferred("monitorable", false)

	queue_free()

extends Area2D

@export var reveal_distance: float = 8.0
var revealed = false
var player_ref = null

func _ready():
	visible = false
	if has_node("Sprite2D"):
		$Sprite2D.visible = false

	player_ref = get_tree().current_scene.find_child("Player", true, false)

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	print("DEBUG espinho pronto")

func _process(delta):
	if not revealed and player_ref:
		if global_position.distance_to(player_ref.global_position) < reveal_distance:
			reveal()

func reveal():
	revealed = true
	visible = true
	if has_node("Sprite2D"):
		$Sprite2D.visible = true
	print("DEBUG espinho revelou")

func _on_body_entered(body):
	print("DEBUG entrou algo:", body.name)

	if not revealed:
		print("DEBUG entrou, mas ainda nao revelou")
		return

	if body.name == "Player":
		print("DEBUG player tocou no espinho")
		body.respawn()

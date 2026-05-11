extends Node

@onready var pickup_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var interaction_player: AudioStreamPlayer = AudioStreamPlayer.new() # NOVO

func _ready():
	add_child(pickup_player)
	add_child(interaction_player) # NOVO

func play_pickup_sound():
	pickup_player.stream = preload("res://audios/415083__harrietniamh__video-game-coin.wav")  # AJUSTE caminho
	pickup_player.volume_db = 1
	pickup_player.play()

func play_interaction_sound():
	interaction_player.stream = preload("res://audios/350867__cabled_mess__blip_c_05 (1).wav")  # AJUSTE caminho!
	interaction_player.volume_db = 6  # ou 12, ou como preferir!
	interaction_player.play()

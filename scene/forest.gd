extends Node2D

func _ready() -> void:
	$AudioStreamPlayer.finished.connect(_on_music_finished)
	$AudioStreamPlayer.play()

func _on_music_finished():
	$AudioStreamPlayer.play()

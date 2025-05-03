extends Node

var music_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var music_stream : AudioStream = preload("res://assets/sounds/music/Retro Mystic.ogg")

func _ready() -> void:
	add_child(music_player)
	music_player.bus = "Music"
	music_player.stream = music_stream
	music_player.play()

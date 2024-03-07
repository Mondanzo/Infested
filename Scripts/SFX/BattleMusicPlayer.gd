extends Node

@export var music_streams: Array[AudioStream]
@export var current_track := 0
@export var transition_duration = 5.0

var stream_players = []

var current_player = null

var is_transitioning = false

func _ready():
	for stream in music_streams:
		var player = AudioStreamPlayer.new()
		player.stream = stream
		add_child(player)
		stream_players.append(player)
	
	current_player = stream_players[current_track]


func transition_to(track_index):
	if is_transitioning:
		return false
	
	if track_index == current_track:
		return false
	
	


func _process(delta):
	pass

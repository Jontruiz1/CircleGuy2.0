extends Node3D

var game_over_music = ["res://GameOver/Music/Track1-GameOver.mp3"]
var musicPlayer = null
var rng = null

func _ready():
	musicPlayer = get_node("GameOverMusic")
	musicPlayer.stop()
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_time_string_from_system())

func change_music():
	var songChoice = rng.randf_range(0, game_over_music.size()-1)
	var song = load(game_over_music[songChoice])
	musicPlayer.stream = song
	musicPlayer.set_volume_db(-20)
	musicPlayer.play()

func _process(delta):
	if(not musicPlayer.playing): change_music()

extends Node3D

var menu_music = ["res://MainMenu/Music/Track1-Menu.mp3"]
var musicPlayer = null
var rng = null

func _ready():
	musicPlayer = get_node("MenuMusic")
	musicPlayer.stop()
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_time_string_from_system())

func change_music():
	var songChoice = rng.randf_range(0, menu_music.size()-1)
	var song = load(menu_music[songChoice])
	musicPlayer.stream = song
	musicPlayer.set_volume_db(-20)
	musicPlayer.play()

func _process(delta):
	if(not musicPlayer.playing): change_music()

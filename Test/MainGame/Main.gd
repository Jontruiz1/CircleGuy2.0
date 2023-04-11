extends Node3D

# health, speed, damage, shoot
var enemyTypes = {
	Color.RED : [2, 2, 2, 50, false], 
	Color.BLUE : [3, 2, 3, 100, false], 
	Color.GREEN : [2, 3, 2, 150, false], 
	Color.PURPLE : [4, 1, 4, 200, true],
	Color.BLACK : [6, 0, 3, 250, true]
	#Color.BROWN :[]
}
var enemyColors = [Color.RED, Color.BLUE, Color.GREEN, Color.PURPLE, Color.BLACK]
var game_music = ["res://MainGame/Music/Track1-InGame.mp3"]

var powerUps = []
var wave = 1
var enemyCount = 0
var pause_menu = null
var player = null
var rng = null
var camera = null
var enemyObj = null
var musicPlayer = null

# Called when the node enters the scene tree or the first time.
func _ready():
	pause_menu = get_node("PauseMenu").get_children()
	musicPlayer = get_node("BkgMusic")
	enemyObj = preload("res://MainGame/Enemy.tscn")
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_time_string_from_system())
	player = get_node("Player")
	spawnWave()

func spawnWave():
	for n in range(wave*4):
		var enemyVariety = rng.randf_range(0, wave)
		enemyVariety = clamp(enemyVariety, 0, enemyColors.size()-1)
		var enemy_x = rng.randf_range(-27, 27)
		var enemy_z = rng.randf_range(-20, 20)
		
		while(pow((enemy_x - player.position.x), 2) + pow((enemy_z - player.position.z), 2) < pow(10, 2)):
			enemy_x = rng.randf_range(-27, 27)
			enemy_z = rng.randf_range(-20, 20) 
		
		var enemyColor = enemyColors[enemyVariety]
		var enemy = enemyObj.instantiate()
		enemy.position = Vector3(enemy_x, .6, enemy_z)
		enemy.init(enemyTypes[enemyColor][0], enemyTypes[enemyColor][1], enemyTypes[enemyColor][2], enemyTypes[enemyColor][3], enemyTypes[enemyColor][4], enemyColor, player)
		add_child(enemy)
		enemyCount += 1
		
func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = not (get_tree().paused)
		for i in range(pause_menu.size()): pause_menu[i].visible = not pause_menu[i].visible
		
		if(get_tree().paused == true): musicPlayer.set_volume_db(musicPlayer.get_volume_db() - 10)
		else: musicPlayer.set_volume_db(musicPlayer.get_volume_db() + 10)

func change_music():
	var songChoice = rng.randf_range(0, game_music.size()-1)
	var song = load(game_music[songChoice])
	musicPlayer.stream = song
	musicPlayer.set_volume_db(-15)
	musicPlayer.play()

func _process(_delta):
	if(not musicPlayer.playing): change_music()
	
	if(enemyCount == 0):
		wave += 1
		spawnWave()

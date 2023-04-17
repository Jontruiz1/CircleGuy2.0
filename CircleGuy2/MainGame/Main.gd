extends Node3D

# health, speed, damage, can shoot, can heal
var enemyTypes = {
		Color.RED : [2, 2, 2, 50, false, false], 
		Color.BLUE : [3, 2, 3, 100, false, false], 
		Color.GREEN : [2, 3, 2, 150, false, false], 
		Color.PURPLE : [4, 1, 4, 200, true, false],
		Color.GRAY : [6, 0, 3, 250, true, false]
}
var bossTypes = {
		Color.BLACK : [20, 0, 3, 500, true, false],
		Color.PINK : [10, 2, 2, 700, true, true]
}
var enemyColors = [Color.RED, Color.BLUE, Color.GREEN, Color.PURPLE, Color.GRAY]
var bossColors = [Color.BLACK, Color.PINK]
var power_normal = [Color.RED, Color.BLUE, Color.GREEN, Color.PURPLE]
var power_boss = [Color.BLACK, Color.PINK]

var game_music = ["res://MainGame/Music/Track1-InGame.mp3"]

var wave = 1
var enemyCount = 0
var radius = pow(10, 2)

var power_up_obj = null
var enemy_obj = null
var player = null

var pause_menu = null
var rng = null
var camera = null
var music_player = null

var generated = false

func generate_rand_pos():
	var x_coord = rng.randf_range(-25, 25)
	var z_coord = rng.randf_range(-18, 18)
	while(pow((x_coord - player.position.x), 2) + pow((z_coord - player.position.z), 2) < radius):
		x_coord = rng.randf_range(-25, 25)
		z_coord = rng.randf_range(-18, 18)
	return [ x_coord, z_coord ]

# generates random color
func generate_color(colors):
	var wave_capped = clamp(wave, 0, colors.size())
	var variety = clamp(rng.randf_range(0, wave_capped), 0, colors.size()-1)
	var color = colors[variety]
	return color

# Called when the node enters the scene tree or the first time.
func _ready():
	
	# loading nodes to be used later
	enemy_obj = preload("res://MainGame/Enemy.tscn")
	power_up_obj = preload("res://MainGame/PowerUp.tscn")
	pause_menu = get_node("PauseMenu").get_children()
	music_player = get_node("BkgMusic")
	player = get_node("Player")
	
	# randiom number generation
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_time_string_from_system())
	
	music_player.finished.connect(func() : change_music())
	change_music()
	
	# spawn initial wave
	spawn_wave()

func normal_wave():
	# spawn wave * 4 enemies
	for n in range(wave*4):
		# generate a random color in the colors list that's limited by the wave
		var enemy_color = generate_color(enemyColors)
		
		# random position for the enemy to spawn at in a specific radius around the player
		var pos = generate_rand_pos()
		
		# instantiate and position an enemy object
		var enemy = enemy_obj.instantiate()
		enemy.position = Vector3(pos[0], .6, pos[1])
		enemy.init(
			enemyTypes[enemy_color][0], 
			enemyTypes[enemy_color][1], 
			enemyTypes[enemy_color][2], 
			enemyTypes[enemy_color][3], 
			enemyTypes[enemy_color][4], 
			enemyTypes[enemy_color][5],
			enemy_color, 
			player)
		add_child(enemy)
		
		enemyCount += 1

func boss_wave():
	# probably can be made into another function 	
	var boss_color = generate_color(bossColors)
	var pos = generate_rand_pos()
	
	# instantiate and position boss
	var boss = enemy_obj.instantiate()
	boss.position = Vector3(pos[0], 1.2, pos[1])
	boss.init(
		bossTypes[boss_color][0],
		bossTypes[boss_color][1], 
		bossTypes[boss_color][2], 
		bossTypes[boss_color][3], 
		bossTypes[boss_color][4], 
		bossTypes[boss_color][5],
		boss_color, 
		player)
	bossTypes[boss_color][0] = clamp(wave * 2, 0, 50);
	boss.set_collision_layer(2)
	
	# make boss big and move up
	boss.scale *= 5
	#boss.position.y += .6
	add_child(boss)
	
	enemyCount += 1

func spawn_power_up():
	var power_up = power_up_obj.instantiate()
	var power_pos = generate_rand_pos()
	power_up.position = Vector3(power_pos[0], .6, power_pos[1])
	
	var color = generate_color(power_normal)
	power_up.init(color)
	add_child(power_up)
	
	generated = true

func spawn_wave():
	if(wave % 5 != 0):
		normal_wave()
	else:
		boss_wave()
		
func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		for i in range(pause_menu.size()): pause_menu[i].visible = not pause_menu[i].visible
		
		if(get_tree().paused == true): music_player.set_volume_db(music_player.get_volume_db() - 10)
		else: music_player.set_volume_db(music_player.get_volume_db() + 10)

func change_music():
	var songChoice = rng.randf_range(0, game_music.size()-1)
	var song = load(game_music[songChoice])
	music_player.stream = song
	music_player.set_volume_db(-15)
	music_player.play()

func _process(_delta):
	if(not generated and wave % 2 == 0): spawn_power_up()
	
	if(enemyCount == 0):
		wave += 1
		generated = false
		spawn_wave()

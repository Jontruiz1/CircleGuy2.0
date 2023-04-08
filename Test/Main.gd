extends Node3D

# health, speed, damage, shoot
var enemyTypes = {
	Color.RED : [2, 2, 2, false], 
	Color.BLUE : [3, 2, 3, false], 
	Color.GREEN : [2, 3, 2, false], 
	Color.PURPLE : [4, 1, 4, true],
	Color.BLACK : [6, 0, 3, true]
}
var enemyColors = [Color.RED, Color.BLUE, Color.GREEN, Color.PURPLE, Color.BLACK]
var powerUps = []
var wave = 1
var enemyCount = 0
var player
var rng
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_time_string_from_system())
	player = get_child(2)
	spawnWave()

func spawnWave():
	for n in range(wave*3):
		var enemyVariety
		if wave >= enemyColors.size(): enemyVariety = rng.randf_range(0, enemyColors.size()-1)
		else: enemyVariety = rng.randf_range(0, wave)
		
		var enemy_x = rng.randf_range(-12, 12)
		var enemy_z = rng.randf_range(-9, 9)
		
		while(pow((enemy_x - player.position.x), 2) + pow((enemy_z - player.position.z), 2) < pow(7, 2)):
			enemy_x = rng.randf_range(-12, 12)
			enemy_z = rng.randf_range(-9, 9) 
		
		var enemyColor = enemyColors[enemyVariety]
		var enemy = preload("res://Enemy.tscn").instantiate()
		enemy.position = Vector3(enemy_x, .6, enemy_z)
		enemy.init(enemyTypes[enemyColor][0], enemyTypes[enemyColor][1], enemyTypes[enemyColor][2], enemyTypes[enemyColor][3], enemyColor, player)
		add_child(enemy)
		enemyCount += 1
		
func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = not (get_tree().paused)



func _process(_delta):
	if(enemyCount == 0):
		wave += 1
		spawnWave()

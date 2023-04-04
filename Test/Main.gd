extends Node3D

# health, speed, damage, shoot
var enemyTypes = {
	Color.RED : [2, 2, 2, false], 
	Color.BLUE : [3, 3, 3, false], 
	Color.GREEN : [2, 4, 2, false], 
	Color.PURPLE : [4, 1, 4, true],
	Color.BLACK : [6, 0, 3, true]
}
var enemyColors = [Color.RED, Color.BLUE, Color.GREEN, Color.PURPLE, Color.BLACK]
var powerUps = []
var wave = 3
var enemyCount = 0
var player
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_time_string_from_system())
	player = get_child(2)
	spawnWave()

func spawnWave():
	for n in range(wave*3):
		var enemy_x = rng.randf_range(-12, 12)
		var enemy_z = rng.randf_range(-9, 9)
		
		while(pow((enemy_x - player.position.x), 2) + pow((enemy_z - player.position.z), 2) < pow(6, 2)):
			enemy_x = rng.randf_range(-12, 12)
			enemy_z = rng.randf_range(-9, 9) 
		
		var enemyColor = enemyColors[rng.randf_range(0, wave)]
		var enemy = preload("res://Enemy.tscn").instantiate()
		enemy.position = Vector3(enemy_x, .6, enemy_z)
		enemy.init(enemyTypes[enemyColor][0], enemyTypes[enemyColor][1], enemyTypes[enemyColor][2], enemyTypes[enemyColor][3], enemyColor, player)
		add_child(enemy)
		enemyCount += 1


func _process(delta):
	if(enemyCount == 0):
		wave += 1
		spawnWave()

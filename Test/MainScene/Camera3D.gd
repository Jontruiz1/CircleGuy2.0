extends Camera3D

var gameManager = null

var player = null
var healthLabel = null
var scoreLabel = null
var waveLabel = null

var currentHP = 0
var currentScore = 0
var currentWave = 0

var timer = Timer.new()

func _ready():
	gameManager = get_tree().get_root().get_node("GameManager")
	
	player = $"../Player"
	healthLabel = get_child(0)
	scoreLabel = get_child(1)
	waveLabel = get_child(2)
	
	healthLabel.text = "Health: " + str(player.health)
	scoreLabel.text = "Score: " + str(player.score)
	waveLabel.text = "Wave: " + str(gameManager.wave)
	currentScore = player.score
	currentHP = player.health
	
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func() : waveLabel.visible = false )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(currentHP > player.health): healthLabel.text = "Health: " + str(player.health)
	if(currentScore < player.score): scoreLabel.text = "Score: " + str(player.score)
	
	if(currentWave < gameManager.wave): 
		waveLabel.text = "Wave: " + str(gameManager.wave)
		waveLabel.visible = true
		currentWave = gameManager.wave
		timer.start()
	
	self.position = Vector3(player.position.x, 6, player.position.z+2)

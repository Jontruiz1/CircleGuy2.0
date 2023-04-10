extends Camera3D
var player = null
var healthLabel = null
var currentHP = 0
var currentScore = 0
var scoreLabel = null


func _ready():
	player = $"../Player"
	healthLabel = get_child(0)
	scoreLabel = get_child(1)
	healthLabel.text = "Health: " + str(player.health)
	scoreLabel.text = "Score: " + str(player.score)
	currentScore = player.score
	currentHP = player.health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(currentHP > player.health): healthLabel.text = "Health: " + str(player.health)
	if(currentScore < player.score): scoreLabel.text = "Score: " + str(player.score)
	self.position = Vector3(player.position.x, 6, player.position.z+2)

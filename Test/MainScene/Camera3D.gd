extends Camera3D
var player
var healthLabel
var currentHP

func _ready():
	player = $"../Player"
	healthLabel = get_child(0)
	currentHP = player.health
	healthLabel.text = "Health: " + str(player.health)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(currentHP > player.health): healthLabel.text = "Health: " + str(player.health)
	self.position = Vector3(player.position.x, 6, player.position.z+2)

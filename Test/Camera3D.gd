extends Camera3D
var player
var healthLabel

func _ready():
	var bullet_node = get_node('Bullet')
	bullet_node.changed.connect(update_text)
	player = $"../Player"
	healthLabel = get_child(0)
	healthLabel.text = "Health: " + str(player.health)

#func update_text():
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = Vector3(player.position.x, 6, player.position.z+2)

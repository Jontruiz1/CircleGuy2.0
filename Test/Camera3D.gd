extends Camera3D
var player

func _ready():
	player = $"../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = Vector3(player.position.x, 6, player.position.z+2)

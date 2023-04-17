extends AnimationPlayer

func _ready():
	self.autoplay = "0"
	self.play()
	get_animation("Rotation").loop_mode = 1

extends Label
var save_path = "user://score.save"
var highscore = null

func load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		highscore = file.get_var()
	else:
		highscore = 0
		
func _ready():
	load_score()
	self.text = "Highscore: " + str(highscore)

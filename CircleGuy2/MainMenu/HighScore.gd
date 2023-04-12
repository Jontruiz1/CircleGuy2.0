extends Label
var highscore_path = "user://score.save"
var score_path = "user://currscore.save"
var curr_score = null

func load_score():
	var score = self.name
	match score:
		"CurrentScore":
			if FileAccess.file_exists(score_path):
				var file = FileAccess.open(score_path, FileAccess.READ)
				curr_score = file.get_var()
			else:
				curr_score = 0
			self.text = "Score: " + str(curr_score)
		"HighScore":
			if FileAccess.file_exists(highscore_path):
				var file = FileAccess.open(highscore_path, FileAccess.READ)
				curr_score = file.get_var()
			else:
				curr_score = 0
			self.text = "HighScore: " + str(curr_score)
		
		
func _ready():
	load_score()
	

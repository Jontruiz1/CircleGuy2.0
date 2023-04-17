extends Button

var menu = []
var main = ["PlayBtn", "QuitBtn", "Title", "Instructions", "HighScore"]
var pause = []
var camera = null

func _ready():
	var button = self
	button.pressed.connect(self._button_pressed)

func _button_pressed():
	var btnName = self.name
	match btnName:
		"PlayBtn":
			get_tree().change_scene_to_file("res://MainGame/Main.tscn")
		"QuitBtn":
			get_tree().quit()
		"MainMenuBtn":
			get_tree().change_scene_to_file("res://MainMenu/Menu.tscn")
		"PlayAgainBtn":
			get_tree().change_scene_to_file("res://MainGame/Main.tscn")

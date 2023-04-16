extends Button

var menu = []
var main = ["PlayBtn", "QuitBtn", "Title", "Instructions", "HighScore"]
var pause = []

func _ready():
	var button = self
	menu = get_tree().get_root().get_child(0).get_node("Camera3D").get_children()
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
		"Instructions":
			for i in pause:
				i.visible = not i.visible
				
			for i in menu:
				if(i.name in main):
					i.visible = not i.visible
		"PlayAgainBtn":
			get_tree().change_scene_to_file("res://MainGame/Main.tscn")

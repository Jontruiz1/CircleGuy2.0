extends Button

func _ready():
	var button = self
	button.pressed.connect(self._button_pressed)

func _button_pressed():
	var btnName = self.name
	match btnName:
		"ResumeBtn":
			var ev = InputEventAction.new()
			ev.action = "pause"
			ev.pressed = true
			Input.parse_input_event(ev)
		"MenuBtn":
			get_tree().paused = not get_tree().paused
			get_tree().change_scene_to_file("res://MainMenu/Menu.tscn")

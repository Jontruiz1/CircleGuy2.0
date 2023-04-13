class_name PowerUp
extends StaticBody3D

var color_matches = {
	Color.RED : "Red", 
	Color.BLUE : "Blue", 
	Color.GREEN : "Green", 
	Color.PURPLE : "Purple",
	Color.BLACK : "Black",
	Color.PINK : "Pink"
}

var type = null
var game_manager = null
var disp_text = null
var disp = Timer.new()

func display():
	match type:
		Color.RED:
			disp_text.text = "Health up!"
		Color.BLUE:
			disp_text.text = "Fire-rate up!"
		Color.GREEN:
			disp_text.text = "Speed up!"
		Color.PURPLE:
			disp_text.text = "Attack up!"
		Color.PINK:
			disp_text.text = "Auto heal up!"
	disp_text.visible = true
	
	disp.timeout.connect(func() : disp_text.visible = false)

func init( color):
	type = color

func _ready():
	disp.wait_time = 2
	disp.one_shot = true
	add_child(disp)
	
	
	disp_text = get_child(2)
	var material = get_child(0).get_active_material(0)
	material.albedo_color = type
	self.name = "Power" + color_matches[type]

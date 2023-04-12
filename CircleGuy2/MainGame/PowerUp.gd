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

func init( color):
	type = color
	set_collision_layer(4)
	set_collision_mask(1)

func _ready():
	var material = get_child(0).get_active_material(0)
	material.albedo_color = type
	self.name = "Power" + color_matches[type]

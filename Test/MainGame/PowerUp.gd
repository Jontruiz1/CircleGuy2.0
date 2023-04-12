class_name PowerUp
extends StaticBody3D

var color_matches = {
	Color.RED : "Red", 
	Color.BLUE : "Blue", 
	Color.GREEN : "Green", 
	Color.PURPLE : "Purple"
}
var type = null

func init(color):
	type = color

func _ready():
	var material = get_node("MeshInstance3D").get_active_material(0)
	material.albedo_color = type
	self.name = "Power" + color_matches[type]

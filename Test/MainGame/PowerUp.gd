class_name Enemy
extends StaticBody3D

var colorMatches = {
	Color.RED : "Red", 
	Color.BLUE : "Blue", 
	Color.GREEN : "Green", 
	Color.PURPLE : "Purple"
}
var type = null



func init(color):
	type = color


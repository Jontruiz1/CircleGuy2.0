extends CharacterBody3D

var health
var speed
var damage
var can_shoot
var type
var target


func init(hp, spd, dmg, shoot, color, player):
	health = hp
	speed = spd
	damage = dmg
	type = color
	shoot = can_shoot
	target = player
	
	# change color
	var material = $MeshInstance3D.get_active_material(0)
	material.albedo_color = color

func _physics_process(delta):
	if health == 0: 
		get_tree().get_root().get_node("GameManager").enemyCount -= 1
		self.queue_free()
	
	
	self.position = self.position.move_toward(target.position, delta * speed)

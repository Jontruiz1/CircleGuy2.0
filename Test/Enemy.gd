extends CharacterBody3D

var health
var speed
var damage
var can_shoot
var type
var target
var shoot_cooldown = Timer.new()
var colorMatches = {Color.RED : "Red", Color.BLUE : "Blue", Color.GREEN : "Green", Color.PURPLE : "Purple", Color.BLACK : "Black"}


func init(hp, spd, dmg, shoot, color, player):
	health = hp
	speed = spd
	damage = dmg
	type = color
	can_shoot = shoot
	target = player
	
	# change color
	var material = $MeshInstance3D.get_active_material(0)
	material.albedo_color = color
	
	match colorMatches[type]:
		&"Purple":
			shoot_cooldown.wait_time = 1
			print("help")
			

func _physics_process(delta):
	if health == 0: 
		get_tree().get_root().get_node("GameManager").enemyCount -= 1
		self.queue_free()
	if can_shoot and shoot_cooldown.is_stopped():
		print("yes")
	self.position = self.position.move_toward(target.position, delta * speed)

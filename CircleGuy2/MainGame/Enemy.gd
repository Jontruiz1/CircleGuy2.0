class_name Enemy
extends CharacterBody3D

var shoot_cooldown = Timer.new()
var colorMatches = {
	Color.RED : "Red", 
	Color.BLUE : "Blue", 
	Color.GREEN : "Green", 
	Color.PURPLE : "Purple", 
	Color.GRAY : "Gray",
	Color.BLACK : "Black"
}

var bulletObj = null
var health = null
var speed = null
var damage = null
var can_shoot = null
var type = null
var target = null
var value = null
var hit = null

func init(hp, spd, dmg, val, shoot, color, player):
	health = hp
	speed = spd
	damage = dmg
	type = color
	can_shoot = shoot
	target = player
	value = val
	
	# change color
	var material = get_node("MeshInstance3D").get_active_material(0)
	material.albedo_color = color
	
	match colorMatches[type]:
		&"Purple":
			shoot_cooldown.wait_time = 2
		&"Black":
			shoot_cooldown.wait_time = .5
	shoot_cooldown.one_shot = true
	add_child(shoot_cooldown)

func _ready():
	set_collision_layer(3)
	set_collision_mask(1)

	hit = get_node("EnemyHit")
	bulletObj = preload("res://MainGame/Bullet.tscn")

# process the shooting if possible
func process_shoot():
	
	if can_shoot and shoot_cooldown.is_stopped():
		var bullet = bulletObj.instantiate()
		
		# place the bullet at the correct starting position
		var enemy_to_target = (Vector2(target.position.x - self.position.x, target.position.z - self.position.z)).normalized()
		bullet.init(self, self.position, enemy_to_target, 3, damage)
		bullet.set_collision_layer(2)
		bullet.set_collision_mask(1)
		
		get_tree().get_root().add_child(bullet)
		
		# scale the bullet to the enemy size
		bullet.scale = (self.scale)
		bullet.position.y -= .2
		
		shoot_cooldown.start()
		
func process_damage(damage):
	health -= damage
	hit.play()
		
func _physics_process(delta):
	if health <= 0: 
		get_tree().get_root().get_node("GameManager").enemyCount -= 1
		self.queue_free()
	process_shoot()
	self.position = self.position.move_toward(target.position, delta * speed)

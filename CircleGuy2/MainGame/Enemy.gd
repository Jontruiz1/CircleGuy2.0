class_name Enemy
extends CharacterBody3D

var shoot_cooldown = Timer.new()
var colorMatches = {
	Color.RED : "Red", 
	Color.BLUE : "Blue", 
	Color.GREEN : "Green", 
	Color.PURPLE : "Purple", 
	Color.GRAY : "Gray",
	Color.BLACK : "Black",
	Color.PINK : "Pink"
}

var bulletObj = null
var health = null
var speed = null
var damage = null
var can_shoot = null
var can_heal = null
var type = null
var target = null
var value = null
var hit = null
var heal = null
var maxHealth = null
var power_up_obj = preload("res://MainGame/PowerUp.tscn")

func replenish():
	health = clamp(health+1, 0, maxHealth) 
	heal.start()

func init(hp, spd, dmg, val, shoot, heal, color, player):
	health = hp
	maxHealth = health
	speed = spd
	damage = dmg
	type = color
	can_shoot = shoot
	can_heal = heal
	target = player
	value = val
	
	# change color
	var material = get_node("MeshInstance3D").get_active_material(0)
	material.albedo_color = color
	
func _ready():

	hit = get_node("EnemyHit")
	bulletObj = preload("res://MainGame/Bullet.tscn")
	
	if(can_heal): 
		print("here")
		heal = Timer.new()
		heal.one_shot = true
		heal.wait_time = 2
		heal.timeout.connect(func() : replenish())
		add_child(heal)
		heal.start()
		
	if(can_shoot):
		match colorMatches[type]:
			&"Purple":
				shoot_cooldown.wait_time = 2
			&"Black":
				shoot_cooldown.wait_time = .5
			&"Pink":
				shoot_cooldown.wait_time = 1.5
			&"Gray":
				shoot_cooldown.wait_time = 1.75
		shoot_cooldown.one_shot = true
		add_child(shoot_cooldown)

# process the shooting if possible
func process_shoot():
	if can_shoot and shoot_cooldown.is_stopped():
		var bullet = bulletObj.instantiate()
		
		# place the bullet at the correct starting position
		var enemy_to_target = (Vector2(target.position.x - self.position.x, target.position.z - self.position.z)).normalized()
		bullet.init(self, self.position, enemy_to_target, 3, damage)
		bullet.set_collision_mask(1)
		bullet.get_child(0).get_active_material(0).albedo_color = Color.RED
		
		get_tree().get_root().add_child(bullet)
		
		# scale the bullet to the enemy size
		bullet.scale = (self.scale)
		bullet.position.y -= .2
		
		shoot_cooldown.start()
		
func process_damage(damage):
	health -= damage
	hit.play()

func process_death():
	if(type == Color.PINK): 
		var pinkMat = load("res://CustomPowerUpSpawn.tres")
		var power_up = power_up_obj.instantiate()
		pinkMat.albedo_color = Color.PINK
		power_up.get_child(0).set_surface_override_material(0, pinkMat)
		power_up.position = self.position
		power_up.init(Color.PINK)
		get_tree().get_root().add_child(power_up)
			
	get_tree().get_root().get_node("GameManager").enemyCount -= 1
	self.queue_free()
	
func _physics_process(delta):
	if health <= 0: process_death()
	process_shoot()
	self.position = self.position.move_toward(target.position, delta * speed)

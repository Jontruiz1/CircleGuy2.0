class_name Player
extends CharacterBody3D

var shoot_cooldown = Timer.new()
var iFrame = Timer.new()
var heal_cooldown = null

var speed = 5.5
var bullet_speed = 5
var health = 6
var maxHealth = 6
var damage = 1
var score = 0

var highscore_path = "user://score.save"
var score_path = "user://currscore.save"

var hurt = null
var shotSound = null
var hit = null
var bulletObj = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# preloads some objects and sets some cooldowns
func _ready():
	# player on layer 1, look for collisions on layer 3
	bulletObj = preload("res://MainGame/Bullet.tscn")
	
	shotSound = get_node("ShootNoise")
	hurt = get_node("HurtNoise")
	hit = get_node("ShotNoise")
	
	# iFrame cooldown 
	iFrame.wait_time = 1
	iFrame.one_shot = true
	add_child(iFrame)
	
	# shooting cooldown
	shoot_cooldown.wait_time = .5
	shoot_cooldown.one_shot = true
	add_child(shoot_cooldown)
	
# updates the current score
func update_score(amount):
	score += amount
	score = clamp(score, 0, 999999999)

# processes updating the highscore and current score files
func process_scores():
	var highscore = 0
	
	if FileAccess.file_exists(highscore_path):
		var file = FileAccess.open(highscore_path, FileAccess.READ)
		highscore = file.get_var()
	
	# if the current score > highscore, update highscore file
	if(highscore < score): 
		var highFile = FileAccess.open(highscore_path, FileAccess.WRITE)
		highscore = score
		highFile.store_var(highscore)
	
	# writes to the current score file
	var scoreFile = FileAccess.open(score_path, FileAccess.WRITE)
	scoreFile.store_var(score)

# processing player shooting
func process_shoot():
	# get shooting direction
	var shoot_input = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down" )
	
	# trying to shoot and there's no cooldown
	if shoot_input and shoot_cooldown.is_stopped():	
		# load and instantiate the bullet
		var bullet = bulletObj.instantiate()
		shotSound.play()
		
		#initialize bullet, add to tree, start shoot cooldown
		bullet.init(self ,self.position, shoot_input, bullet_speed, damage)
		bullet.set_collision_mask(2)
		bullet.get_child(0).get_active_material(0).albedo_color = Color.BLUE
		
		get_tree().get_root().add_child(bullet)
		shoot_cooldown.start()	

# processing player movement
func process_move(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
# processes damage and updates the score based on it
# depends on update_score()
func process_damage(damage_amt, currVal):
	if(iFrame.is_stopped()):
		health -= damage_amt
		update_score(-currVal*.5)	
		hit.play()
		hurt.play()
		iFrame.start()


# processes the player dying
# depends on process_scores()
func game_over():
	# file accessing to update the current scores
	process_scores()
	
	# change scene to game over scren
	get_tree().change_scene_to_file("res://GameOver/GameOver.tscn")	

# gets the pure object name of the collider
func parse_collision(collider):
	if(collider == null): return
	var collideName = collider.name
	collideName = collideName.replace("@", "").rstrip("0123456789")
	return collideName
	
# matches the collision name,
# depends on process_damage() and parse_collision
func match_collision(collider, collideName):
	# match the collision with a known collider
	match collideName:
		"Enemy":
			process_damage(collider.damage, collider.value)
		"PowerRed":
			maxHealth = clamp(maxHealth+1, 3, 15)
			health = clamp(health+1, 3, maxHealth)
			collider.display()
		"PowerBlue":
			shoot_cooldown.wait_time = clamp(shoot_cooldown.wait_time-.05, .2, .5)
			collider.display()
		"PowerGreen":
			speed = clamp(speed+.2, 3, 8)
			collider.display()
		"PowerPurple":
			damage = clamp(damage+.5, 1, 5)
			collider.display()
		"PowerPink":
			if(heal_cooldown == null):
				heal_cooldown = Timer.new()
				heal_cooldown.wait_time = 7
				heal_cooldown.timeout.connect(
						func() : 
							health = clamp(health+1, 3, maxHealth)
							heal_cooldown.start())
				add_child(heal_cooldown)
				heal_cooldown.start()
			else:
				heal_cooldown.wait_time = clamp(heal_cooldown.wait_time - .2, 4, 7)
			collider.display()


# will handle colliding with enemies
# depends on match_collision and parse_collision()
func process_collision():
	# gets number of collisions
	var collideCount = get_slide_collision_count()
	
	if collideCount >= 1:
		var collision = get_slide_collision(collideCount-1)
		var collider = collision.get_collider()
		
		# parse the collision name to remove the @ symbols and numbers
		var collideName = parse_collision(collider)
		match_collision(collider, collideName)
		
# processes functions every frame
# depends on 
#	process_collision(), process_move()
# 	process_shoot() and game_over()
func _physics_process(delta):
	process_collision()
	process_move(delta)
	process_shoot()
	move_and_slide()
	if(health <= 0): game_over()

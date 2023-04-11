class_name Player
extends CharacterBody3D


var speed = 6
var bullet_speed = 5
var shoot_cooldown = Timer.new()
var iFrame = Timer.new()
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

func _ready():
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
	

# processing player shooting
func process_shoot():
	# get shooting direction
	var shoot_input = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down" )
	
	# trying to shoot and there's no cooldown
	if shoot_input and shoot_cooldown.is_stopped():	
		# load and instantiate the bullet
		var bullet = bulletObj.instantiate()
		bullet.set_collision_mask(1)
		bullet.set_collision_layer(2)
		shotSound.play()
		
		#initialize bullet, add to tree, start shoot cooldown
		bullet.init(self ,self.position, shoot_input, bullet_speed, damage)
		
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
		
func update_score(amount):
	score += (amount * .5)
	score = clamp(score, 0, 999999999)

func process_damage(damage_amt, currVal):
	if(iFrame.is_stopped()):
		health -= damage_amt
		update_score(-currVal)	
		hit.play()
		hurt.play()
		iFrame.start()

func parse_collision(collider):
	if(collider == null): return
	var collideName = collider.name
	collideName = collideName.replace("@", "").rstrip("0123456789")
	return collideName
	
	
# will handle colliding with enemies
func process_collision():
	# gets number of collisions
	var collideCount = get_slide_collision_count()
	
	if collideCount >= 1:
		var collision = get_slide_collision(collideCount-1)
		var collider = collision.get_collider()
		
		# parse the collision name to remove the @ symbols and numbers
		var collideName = parse_collision(collider)
		
		# match the collision with a known collider
		match collideName:
			"Enemy":
				process_damage(collider.damage, collider.value)
					
func game_over():
	var highscore = 0
	var prevScore = score
	
	if FileAccess.file_exists(highscore_path):
		var file = FileAccess.open(highscore_path, FileAccess.READ)
		highscore = file.get_var()
	
	if(highscore < score): highscore = score
	
	var highFile = FileAccess.open(highscore_path, FileAccess.WRITE)
	var scoreFile = FileAccess.open(score_path, FileAccess.WRITE)
	highFile.store_var(highscore)
	scoreFile.store_var(score)
	
	#var savegame = File.new()
	#var same_path = "res://savegame.save"
	get_tree().change_scene_to_file("res://GameOver/GameOver.tscn")	

func _physics_process(delta):
	process_collision()
	process_move(delta)
	process_shoot()
	move_and_slide()
	if(health <= 0): game_over()

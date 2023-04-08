extends CharacterBody3D


const SPEED = 5.0
var bullet_speed = 5
var shoot_cooldown = Timer.new()
var iFrame = Timer.new()
var health = 6
var damage = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	iFrame.wait_time = 1
	iFrame.one_shot = true
	add_child(iFrame)
	
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
		var bullet = preload("res://Bullet.tscn").instantiate()
		
		#initialize bullet, add to tree start shoot cooldown
		bullet.init(self.position, shoot_input, bullet_speed, damage)
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
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

# will handle colliding with enemies
func process_collision():
	var collideCount = get_slide_collision_count()
	
	"print( collideCount)
	for i in range(collideCount):
		print(get_slide_collision(i).get_collider().to_string())
	print('\n')"

func _physics_process(delta):
	#process_collision()
	process_move(delta)
	process_shoot()
	move_and_slide()

extends KinematicBody2D


export (int) var speed = 200
var velocity = Vector2()
var bullet = preload('res://Bullet.tscn')
var can_shoot = true
var time = Timer.new()
signal shoot(bullet, direction, location)

# Called when the node enters the scene tree for the first time.
func _ready():
	time.connect("timeout",self,"shooting")
	time.wait_time = 1
	time.one_shot = true
	add_child(time)
	
func movement():
	velocity = Vector2()
	
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
func shooting():
		if Input.is_action_pressed('ui_left'):
			emit_signal("shoot", bullet, rotation, position)
			time.start()
			print('left')
		if Input.is_action_pressed('ui_down'):
			time.start()
			print('down')
		if Input.is_action_pressed('ui_right'):
			time.start()
			print('right')
		if Input.is_action_pressed('ui_up'):
			time.start()
			print('up')
func _physics_process(_delta):
	shooting()
	movement()
	velocity = move_and_slide(velocity)

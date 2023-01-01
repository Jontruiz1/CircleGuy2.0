extends KinematicBody2D
export (int) var speed = 200
var velocity = Vector2()
var bullet = preload('res://Bullet.tscn')
var can_shoot = true
signal shoot(bullet, direction, location)
# Called when the node enters the scene tree for the first time.
func _ready():
	print(bullet)
	
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
	if(can_shoot):
		if Input.is_action_pressed('ui_left'):
			emit_signal("shoot", bullet, rotation, position)
			print('left')
		if Input.is_action_pressed('ui_down'):
			print('down')
		if Input.is_action_pressed('ui_right'):
			print('right')
		if Input.is_action_pressed('ui_up'):
			print('up')
func _physics_process(_delta):
	shooting()
	movement()
	velocity = move_and_slide(velocity)

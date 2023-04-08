class_name Bullet
extends CharacterBody3D


var shoot_direction
var speed
var damage
var t = Timer.new()
var target

#initialize the bullet
func init(playerpos, shoot_input, spd, dmg):
	target = playerpos
	shoot_direction = (transform.basis * Vector3(shoot_input.x, 0, shoot_input.y)).normalized()
	damage = dmg
	speed = spd;
	self.position =  Vector3(target.x + shoot_input.x, target.y, target.z + shoot_input.y)
	self.rotation = (transform.basis * Vector3(shoot_input.x, 0, shoot_input.y)).normalized()
	
	
#make the bullet disappear after a 5 seconds so it doesn't lag the shit out of the game
func _ready():
	self.look_at(target)
	t.wait_time = 5
	t.one_shot = true
	t.timeout.connect(func() : queue_free())
	get_tree().get_root().add_child(t)
	t.start()
	
# processes the collisions
# if the bullet collides with a wall, it should just disappear
func process_collision():
	var collideCount = get_slide_collision_count()
	if collideCount:
		var collision = get_slide_collision(collideCount-1)
		if(self.get_rid() != collision.get_collider_rid()):
			var obj = collision.get_collider(0)
			self.queue_free()
			obj.health -= self.damage



func _physics_process(delta):
	self.position = Vector3(self.position.x + (delta * shoot_direction.x) * speed , self.position.y + (delta*shoot_direction.y) * speed, self.position.z + (delta * shoot_direction.z) * speed)
	move_and_slide()

class_name Bullet
extends CharacterBody3D

var lifeTime = Timer.new()

var shoot_direction = null
var speed = null
var damage = null
var target = null
var source = null
var origin = null
var hit = null

#initialize the bullet
func init(src, playerpos, shoot_input, spd, dmg):
	target = playerpos
	shoot_direction = (transform.basis * Vector3(shoot_input.x, 0, shoot_input.y)).normalized()
	damage = dmg
	speed = spd;
	origin = src
	source = src.name.replace("@", "").rstrip("0123456789")
	self.position =  Vector3(target.x + shoot_input.x, target.y, target.z + shoot_input.y)
	self.rotation = (transform.basis * Vector3(shoot_input.x, 0, shoot_input.y)).normalized()
	
	
#make the bullet disappear after a 5 seconds so it doesn't lag the shit out of the game
func _ready():
	hit = $AudioStreamPlayer
	self.look_at(target)
	lifeTime.wait_time = 7
	lifeTime.one_shot = true
	lifeTime.timeout.connect(func() : queue_free())
	get_tree().get_root().add_child(lifeTime)
	lifeTime.start()
	
func parse_collision(collider):
	if(collider == null): return ""
	var collideName = collider.name
	collideName = collideName.replace("@", "").rstrip("0123456789")
	return collideName
	
	
# processes the collisions
# if the bullet collides with a wall, it should just disappear
func process_collision():
	var collideCount = get_slide_collision_count()
	
	if collideCount >= 1:
		var collision = get_slide_collision(collideCount-1)
		var collider = collision.get_collider()
		var collideName = parse_collision(collider)
		
		if(collideName.contains("Wall")): queue_free()
		if(source != collideName):
			match collideName:
				"Player":
					collider.process_damage(self.damage, origin.value)
					queue_free()
				"Enemy":
					collider.process_damage(self.damage)
					if(collider.health <= 0):
						origin.update_score(collider.value)
					queue_free()


func process_move(delta):
	self.position = Vector3(self.position.x + (delta * shoot_direction.x) * speed , self.position.y + (delta*shoot_direction.y) * speed, self.position.z + (delta * shoot_direction.z) * speed)

func _physics_process(delta):
	if(origin == null): queue_free()
	process_move(delta)
	process_collision()
	move_and_slide()

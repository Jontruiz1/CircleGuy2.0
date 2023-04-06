extends CharacterBody3D

var shoot_direction
var speed
var damage
var t = Timer.new()
func init(playerpos, shoot_input, spd, dmg):
	shoot_direction = (transform.basis * Vector3(shoot_input.x, 0, shoot_input.y)).normalized()
	damage = dmg
	speed = spd;
	self.position =  Vector3(playerpos.x + shoot_input.x, playerpos.y, playerpos.z + shoot_input.y)
	#self.rotation = (transform.basis * Vector3(shoot_input.x, 0, shoot_input.y)).normalized()
	t.set_one_shot(true)
	t.connect("timeout", self, "queue_free")
	t.set_wait_time(5)
	add_child(t)
	t.start()

func _physics_process(delta):
	var collideCount = get_slide_collision_count()
	self.position = Vector3(self.position.x + (delta * shoot_direction.x) * speed , self.position.y + (delta*shoot_direction.y) * speed, self.position.z + (delta * shoot_direction.z) * speed)
	move_and_slide()
"""
	if collideCount:
		var collision = get_slide_collision(collideCount-1)
		if(self.get_rid() != collision.get_collider_rid()):
			var obj = collision.get_collider(0)
			self.queue_free()
			obj.health -= self.damage
"""

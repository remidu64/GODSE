extends RigidBody3D

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(10)
	
func _physics_process(delta: float) -> void:
	if position.y < -100:
		yeet()
	for i in get_colliding_bodies():
		if i is CharacterBody3D:
			i.health -= 20
			yeet()
		if i.is_in_group("map"):
			yeet()

@rpc("any_peer")			
func yeet():
	self.queue_free()

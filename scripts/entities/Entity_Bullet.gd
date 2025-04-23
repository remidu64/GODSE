extends RigidBody3D

var shooter = null

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(10)
	

func _physics_process(delta: float) -> void:
	for i in get_colliding_bodies():
		if i is CharacterBody3D:
			i.health -= 20
			self.queue_free()

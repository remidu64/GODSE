extends RigidBody3D

@onready var check: Area3D = $"Area3D"

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(10)
	apply_impulse(-get_global_transform_interpolated().basis.z * 100)
	
func _physics_process(delta: float) -> void:
		
	if position.y < -100:
		queue_free()
	for i in get_colliding_bodies():
		if i is CharacterBody3D:
			queue_free()
			i.health -= 20
		#if i.is_in_group("map"):
			#queue_free()

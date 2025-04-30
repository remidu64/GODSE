extends RigidBody3D

@onready var tester: MeshInstance3D = $test

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(10)
	
func _physics_process(delta: float) -> void:
	look_at(tester.global_position)
	tester.global_position = linear_velocity + global_position
	if position.y < -100:
		queue_free()
	for i in get_colliding_bodies():
		if i is CharacterBody3D:
			queue_free()
			i.health -= 20
		if i.is_in_group("map"):
			pass
			# queue_free()
			
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	pass 
	# apply_torque_impulse(Vector3(0, 0, 1) * global_transform.basis.inverse())

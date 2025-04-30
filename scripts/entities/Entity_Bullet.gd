extends RigidBody3D

@onready var tester: Node3D = $test

var diff = Vector3(0, 0, 0)

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(10)
	
func _physics_process(delta: float) -> void:
	if linear_velocity.length() > 5:
		tester.look_at(global_transform.origin + linear_velocity)
	diff = (tester.rotation - rotation)
	print(diff)
		
	if position.y < -100:
		queue_free()
	for i in get_colliding_bodies():
		if i is CharacterBody3D:
			queue_free()
			i.health -= 20
		if i.is_in_group("map"):
			queue_free()
			
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if linear_velocity.length() > 5:
		apply_torque_impulse(diff*global_transform.basis.inverse())
	# apply_torque_impulse(Vector3(0, 0, 1) * global_transform.basis.inverse())

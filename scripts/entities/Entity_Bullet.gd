extends RigidBody3D

const TINY_VECTOR = Vector3.LEFT * 0.001
var damage = 0
var knockback = 0
@export var shooter = "john GODSE"

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(10)
	apply_impulse(-get_global_transform_interpolated().basis.z * 50)
	print(shooter)
	
func _physics_process(delta: float) -> void:
	if position.y < -100:
		queue_free()
	for i in get_colliding_bodies():
		if i is CharacterBody3D:
			queue_free()
			i.health -= damage
			i.velocity.x -= sin(rotation.y) * knockback
			i.velocity.z -= cos(rotation.y) * knockback
			i.velocity.y += knockback
			print(shooter)
		if i.is_in_group("map"):
			queue_free()
	look_at(global_position + linear_velocity + TINY_VECTOR)

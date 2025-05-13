extends RigidBody3D

var damage = 0
var knockback = 0
var start_speed = 0
@export var shooter = null

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(10)
	apply_impulse(-get_global_transform_interpolated().basis.z * start_speed)
	
func _physics_process(delta: float) -> void:
	if position.y < -100:
		queue_free()
	for i in get_colliding_bodies():
		if i is CharacterBody3D:
			queue_free()
			i.velocity.x -= sin(rotation.y) * knockback
			i.velocity.z -= cos(rotation.y) * knockback
			i.velocity.y += knockback
			Global.hit.emit(shooter, i, damage)
		if i.is_in_group("map"):
			queue_free()
	if global_position + linear_velocity != global_position:
		look_at(global_position + linear_velocity)

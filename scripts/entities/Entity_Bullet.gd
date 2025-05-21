extends RigidBody3D

var damage = 0
var knockback = 0
var start_speed = 0
var spread = 0
@export var shooter = 5

func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(10)
	apply_impulse(get_spread_dir(shooter.raycast.get_global_transform_interpolated().basis, spread) * start_speed)
	
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
		
func get_spread_dir(camera_global_basis : Basis, spread_degrees: float) -> Vector3:
	var twist : float = randf_range(0, TAU)
	var axis := Vector3(cos(twist), sin(twist), 0)
  
	var angle := (1.0 - sqrt(1.0 - sqrt(randf()))) * deg_to_rad(spread_degrees) # Superior distribution
  #var angle := sqrt(randf()) * spread_degrees # Uniform spread, use instead if prefered
  
  # Negative because cameras in Godot point backwards
	return -camera_global_basis.z.rotated(camera_global_basis * axis, angle)

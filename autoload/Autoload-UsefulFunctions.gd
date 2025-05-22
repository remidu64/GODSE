extends Node

const CHARS: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const CHARS_LEN: int = len(CHARS)

func random_string(length) -> String:
	var result: String = ""
	for i in range(length):
		result += CHARS[randi() % CHARS_LEN]
	return result
	
func get_spread_dir(camera_global_basis : Basis, spread_degrees: float, twist_rand: float, rand: float) -> Vector3:
	var twist : float = twist_rand
	var axis := Vector3(cos(twist), sin(twist), 0)
  
	var angle := (1.0 - sqrt(1.0 - sqrt(rand))) * deg_to_rad(spread_degrees) # Superior distribution
  #var angle := sqrt(randf()) * spread_degrees # Uniform spread, use instead if prefered
  
  # Negative because cameras in Godot point backwards
	return -camera_global_basis.z.rotated(camera_global_basis * axis, angle)

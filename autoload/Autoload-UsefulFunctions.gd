extends Node

func Cart2Polar(position: Vector3):
	pass
	
func Polar2Cart(position: Vector3): # vector must be (distance, y angle, x angle)
	var x = position[0] * sin(position[1]) * cos(position[2])
	var y = position[0] * cos(position[2])
	var z = position[0] * sin(position[1]) * sin(position[2])
	return Vector3(x, y, z)

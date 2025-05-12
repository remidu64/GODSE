extends Node

# to let the other nodes know that the options have changed
signal changed()

var sensitivity = 0.5
var fov = 75
var shadows = true
var fps = false

func get_option(str:String):
	match str:
		"FOV":
			return fov
		"Sensitivity":
			return sensitivity
		"Shadows":
			return shadows
		"FPS":
			return fps

func set_option(str:String, value):
	match str:
		"FOV":
			fov = int(value)
		"Sensitivity":
			sensitivity = float(value)
		"Shadows":
			shadows = bool(value)
		"FPS":
			fps = bool(value)
	changed.emit()

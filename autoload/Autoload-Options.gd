extends Node

# to let the other nodes know that the options have changed
signal changed()

var sensitivity = 0.5
var fov = 75
var shadows = true
var fps = false
var fullscreen = false

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
		"Fullscreen":
			return fullscreen

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
		"Fullscreen":
			fullscreen = bool(value)
			
	changed.emit()

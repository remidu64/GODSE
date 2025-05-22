extends Node

# to let the other nodes know that the options have changed
signal changed()

var sensitivity = 0.5
var fov = 75
var shadows = true
var fps = false
var fullscreen = false
var shooting_bar = false
var hitmarker_sound = 0

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
		
	if not SaveData.load_from_config("FOV"):
		SaveData.save_to_config("FOV", fov)
	else:
		fov = SaveData.load_from_config("FOV")
		
	if not SaveData.load_from_config("Sensitivity"):
		SaveData.save_to_config("Sensitivity", sensitivity)
	else:
		sensitivity = SaveData.load_from_config("Sensitivity")
		
	if not SaveData.load_from_config("Shadows"):
		SaveData.save_to_config("Shadows", shadows)
	else:
		shadows = SaveData.load_from_config("Shadows")
		
	if not SaveData.load_from_config("FPS"):
		SaveData.save_to_config("FPS", fps)
	else:
		fps = SaveData.load_from_config("FPS")
		
	if not SaveData.load_from_config("Fullscreen"):
		SaveData.save_to_config("Fullscreen", fullscreen)
	else:
		fullscreen = SaveData.load_from_config("Fullscreen")
		
	if not SaveData.load_from_config("ShootingBar"):
		SaveData.save_to_config("ShootingBar", shooting_bar)
	else:
		fullscreen = SaveData.load_from_config("ShootingBar")
		
	if not SaveData.load_from_config("HitmarkerSound"):
		SaveData.save_to_config("HitmarkerSound", hitmarker_sound)
	else:
		fullscreen = SaveData.load_from_config("HitmarkerSound")

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
		"ShootingBar":
			return shooting_bar
		"HitmarkerSound":
			return hitmarker_sound

func set_option(str:String, value):
	match str:
		"FOV":
			fov = int(value)
			SaveData.save_to_config("FOV", int(value))
		"Sensitivity":
			sensitivity = float(value)
			SaveData.save_to_config("Sensitivity", float(value))
		"Shadows":
			shadows = bool(value)
			SaveData.save_to_config("Shadows", bool(value))
		"FPS":
			fps = bool(value)
			SaveData.save_to_config("FPS", bool(value))
		"Fullscreen":
			fullscreen = bool(value)
			SaveData.save_to_config("Fullscreen", bool(value))
		"ShootingBar":
			shooting_bar = bool(value)
			SaveData.save_to_config("ShootingBar", bool(value))
		"HitmarkerSound":
			hitmarker_sound = int(value)
			SaveData.save_to_config("HitmarkerSound", int(value))
			
	changed.emit()

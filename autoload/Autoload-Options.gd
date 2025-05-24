extends Node

# to let the other nodes know that the options have changed
signal changed()

var sensitivity = 0.5
var fov = 75
var fps = false
var fullscreen = false
var shooting_bar = false
var hitmarker_sound = 0

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
	
	if SaveData.load_from_config("FOV") == null:
		SaveData.save_to_config("FOV", fov)
	else:
		fov = SaveData.load_from_config("FOV")
		
	if SaveData.load_from_config("Sensitivity") == null:
		SaveData.save_to_config("Sensitivity", sensitivity)
	else:
		sensitivity = SaveData.load_from_config("Sensitivity")
		
	if SaveData.load_from_config("FPS") == null:
		SaveData.save_to_config("FPS", fps)
	else:
		fps = SaveData.load_from_config("FPS")
		
	if SaveData.load_from_config("Fullscreen") == null:
		SaveData.save_to_config("Fullscreen", fullscreen)
	else:
		fullscreen = SaveData.load_from_config("Fullscreen")
		
	if SaveData.load_from_config("ShootingBar") == null:
		SaveData.save_to_config("ShootingBar", shooting_bar)
	else:
		shooting_bar = SaveData.load_from_config("ShootingBar")
		
	if SaveData.load_from_config("HitmarkerSound") == null:
		SaveData.save_to_config("HitmarkerSound", hitmarker_sound)
	else:
		hitmarker_sound = SaveData.load_from_config("HitmarkerSound")

func get_option(str:String):
	match str:
		"FOV":
			return fov
		"Sensitivity":
			return sensitivity
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

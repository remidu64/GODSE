extends Node

const save_path = "user://config.cfg"
var config = ConfigFile.new()

func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		return
	if config.load(save_path) != OK:
		push_error("user://config.cfg doesnt exist or wasnt loaded properly, creating a new config file")
		config.save(save_path)

func save_to_config(name_uwu: String, var_to_save):
	config.set_value("file", name_uwu, var_to_save)
	config.save(save_path)
	
func load_from_config(name_uwu: String):
	var file = config.load(save_path)
	
	if file != OK:
		push_error("user://config.cfg doesnt exist or wasnt loaded properly, creating a new config file")
		return
	
	return config.get_value("file", name_uwu)

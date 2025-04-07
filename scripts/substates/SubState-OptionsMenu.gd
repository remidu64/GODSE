extends Control

@onready var actualOptions: Control = $ActualOptions

@export var inGame:bool = false

func exit_menu():
	for i in actualOptions.get_children():
		i.save_option()
	
	if !inGame:
		pass # will change all this when we have a main menu and shit like that ykyk

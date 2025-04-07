extends Control

@onready var tab_container: TabContainer = $ActualOptions/TabContainer

@export var inGame:bool = false

func exit_menu():
	for i in tab_container.get_children():
		for u in i.get_children():
			u.save_option() # colon three
	
	if !inGame:
		pass # will change all this when we have a main menu and shit like that ykyk

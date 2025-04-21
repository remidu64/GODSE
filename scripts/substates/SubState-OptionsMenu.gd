extends Control

@onready var tab_container: TabContainer = $TabContainer

@export var inGame:bool = false


func exit_menu():
	for i in tab_container.get_children():
		for u in i.get_children():
			for r in u.get_children():
				r.save_option() # ill fix this shit later i just need it to work for now
	
	if !inGame:
		pass # will change all this when we have a main menu and shit like that ykyk

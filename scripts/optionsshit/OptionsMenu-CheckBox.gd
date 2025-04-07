extends CheckBox

@export var Property:String

func _ready():
	button_pressed = Options.get_option(Property)

func _process(delta: float) -> void:
	text = str(Property) # why the fuck am i turning a string into a string (imma leave that in its kinda funny)

func save_option():
	Options.set_option(Property, button_pressed)

extends CheckBox

@export var Property:String

func _ready():
	button_pressed = Options.get_option(Property)

func _process(delta: float) -> void:
	text = "Shoot Cooldown Progress Bar"

func save_option():
	Options.set_option(Property, button_pressed)

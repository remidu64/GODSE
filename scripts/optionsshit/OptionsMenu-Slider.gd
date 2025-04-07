extends HSlider

## the property, accepts "Sensitivity" and "FOV"
@export var Property:String

func _process(delta: float) -> void:
	$Label.text = "%s (%s)" % [Property, value] # fancy

func save_option():
	Options.set_option(Property, value)

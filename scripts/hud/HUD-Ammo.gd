extends Control

@onready var ammo: Label = $AmmoCount

var currentammo: int = 1
var maxammo: int = 1

func _physics_process(delta: float) -> void:
		ammo.text = "%s / %s" % [currentammo, maxammo]

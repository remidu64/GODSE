extends Node

@onready var health_bar: ColorRect = $Background/Bar
@onready var health_num: Label = $Health

var hp = 1
var max_hp = 1
var ratio = 0

func _physics_process(delta: float) -> void:
	ratio = hp/max_hp
	
	health_bar.scale = Vector2(ratio, 1)
		
	if ratio <= 0.1:
		health_num.text = UsefulFunctions.random_string(randi() % 15)
	else:
		health_num.text = str(int(hp))

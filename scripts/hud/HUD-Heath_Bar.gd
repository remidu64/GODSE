extends Node

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health_num: Label = $Health

var hp: float = 1
var max_hp: float = 1
var ratio: float = 0

func _physics_process(delta: float) -> void:
	ratio = hp/max_hp
	
	health_bar.value = ratio * 100
		
	if ratio <= 0.1:
		health_num.text = UsefulFunctions.random_string(randi() % 15)
	else:
		health_num.text = str(int(hp))+"/"+str(int(max_hp))

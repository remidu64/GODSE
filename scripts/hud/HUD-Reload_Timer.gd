extends Control

@onready var health_bar: TextureProgressBar = $ShootingTimerBar
@onready var health_num: Label = $ShootingTimer

var hp: float = 1
var max_hp: float = 1
var ratio: float = 0

func _physics_process(delta: float) -> void:
	if Global.Player :
		if Global.Player.reloading:
			visible = true
			ratio = hp/max_hp
			health_bar.value = ratio * 100
			health_num.text = "Reloading time: %ss" % snapped(hp, 0.1)
		else:
			visible = false
	

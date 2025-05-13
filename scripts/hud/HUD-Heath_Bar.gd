extends Node

@onready var health_bar: ColorRect = $Background/Bar

var bar_size = 1

func _physics_process(delta: float) -> void:
	health_bar.scale = Vector2(bar_size, 1)

extends Node3D

@onready var SunLight: DirectionalLight3D = $DirectionalLight3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("disableShadows"):
		SunLight.shadow_enabled = !SunLight.shadow_enabled

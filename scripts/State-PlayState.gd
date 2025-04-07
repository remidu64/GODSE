extends Node3D

@onready var SunLight: DirectionalLight3D = $DirectionalLight3D

func _ready():
	Options.changed.connect(toggle_shadows)

func toggle_shadows():
	SunLight.shadow_enabled = Options.shadows

extends Node3D

# @onready var camera: Camera3D = $"Camera3D"
@onready var menu: CanvasLayer = $"OptionsHud"
@onready var playercount: Label = $"OptionsHud/DSMenu/Label"

func _ready() -> void:
	# camera.make_current()
	if not multiplayer.is_server():
		return
	menu.visible = true
	Engine.max_fps = 30
		
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	playercount.text = "Current Player Count: %s" % get_tree().get_nodes_in_group("players").size()

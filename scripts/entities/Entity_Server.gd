extends Node3D

@onready var menu: CanvasLayer = $"OptionsHud"
@onready var playercount: Label = $"OptionsHud/DSMenu/Label"

func _exit_tree() -> void:
	Networking.remove_server_request.emit()

func _ready() -> void:
	if not multiplayer.is_server():
		return 
	menu.visible = true
	Engine.max_fps = 30
	Global.Server = self
		
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	playercount.text = "Current Player Count: %s" % get_tree().get_nodes_in_group("players").size()
	
func return_spread_vector(shooter_basis, spread) -> Vector3:
	return UsefulFunctions.get_spread_dir(shooter_basis, spread, randf_range(0, TAU), randf())

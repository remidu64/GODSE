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
		
func _physics_process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	playercount.text = "Current Player Count: %s" % get_tree().get_nodes_in_group("players").size()

func get_spread_dir(camera_global_basis : Basis, spread_degrees: float) -> Vector3:
	var twist : float = randf_range(0, TAU)
	var axis := Vector3(cos(twist), sin(twist), 0)
  
	var angle := (1.0 - sqrt(1.0 - sqrt(randf()))) * deg_to_rad(spread_degrees) # Superior distribution
  #var angle := sqrt(randf()) * spread_degrees # Uniform spread, use instead if prefered
  
  # Negative because cameras in Godot point backwards
	return -camera_global_basis.z.rotated(camera_global_basis * axis, angle)

extends Node

var gameVersion = "0.1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	DisplayServer.window_set_title("GODSE v%s" % GameInfo.gameVersion)

extends Node

var gameVersion = "0.7"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# just putting the window_set_title shit here doesnt work, so it sets the version after 0.1 seconds
	await get_tree().create_timer(0.1).timeout
	DisplayServer.window_set_title("GODSE v%s" % GameInfo.gameVersion)

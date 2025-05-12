extends Node

signal play_state_loaded
signal player_loaded
signal firin(projectile)
signal hit(shooter)
signal leaving()

# player node, set in Entity-Player.gd
var Player = null

# name for the player
var Name = "john GODSE"

func _ready() -> void:
	player_loaded.connect(set_player_name)
		
func set_player_name():
	Player.player_name = Name

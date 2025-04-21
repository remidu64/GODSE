extends Node

signal play_state_loaded

# player node, set in Entity-Player.gd
var Player = null

@onready var DebugLabel: Label = $DebugLabel

# built in functions

func _process(delta):
	get_player_stats()

# custom functions
func get_player_stats():
	if Player == null:
		return
	DebugLabel.text = "FPS: %s\nPlayer Velocity: %s\nPlayer HP: %s\nPlayer rotation y: %s\nPlayer rotation x: %s" % [Engine.get_frames_per_second(), Player.velocity, Player.health, Player.raycast.global_rotation.y, Player.raycast.global_rotation.x]

extends Node

signal play_state_loaded

# player node, set in Entity-Player.gd
var Player = null

@onready var DebugLabel: Label = $DebugLabel

# built in functions

func _process(delta):
	DebugLabel.text = "FPS: %s" % Engine.get_frames_per_second()
	
	get_player_stats()

# custom functions

func get_player_stats():
	if Player == null:
		return
	
	DebugLabel.text += "\nPlayer Velocity: %s" % Player.velocity
	DebugLabel.text += "\nPlayer HP: %s" % Player.health

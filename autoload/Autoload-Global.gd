extends Node

signal play_state_loaded
signal player_loaded
signal firin(projectile)
signal hit(shooter)

# player node, set in Entity-Player.gd
var Player = null

# name for the player
var Name = "john GODSE"

@onready var DebugLabel: Label = $DebugLabel

func _ready() -> void:
	player_loaded.connect(set_player_name)

# built in functions

func _process(delta):
	get_player_stats()

# custom functions

func get_player_stats():
	if not Player == null:
		DebugLabel.text = "FPS: %s\nPlayer Velocity: %s\nPlayer HP: %s\nPlayer rotation y: %s\nPlayer rotation x: %s" % [Engine.get_frames_per_second(), Player.velocity, Player.health, Player.raycast.global_rotation.y, Player.raycast.global_rotation.x]
		Player.player_name = Name
		DebugLabel.visible = true
	else:
		DebugLabel.visible = false
		
func set_player_name():
	Player.player_name = Name

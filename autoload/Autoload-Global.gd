extends Node

signal play_state_loaded

@onready var DebugLabel: Label = $DebugLabel

func _process(delta):
	DebugLabel.text = "FPS: %s" % Engine.get_frames_per_second()

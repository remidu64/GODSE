extends Node

@onready var DebugLabel: Label = $DebugLabel

func _process(delta):
	DebugLabel.text = "FPS: %s" % Engine.get_frames_per_second()

extends Node3D

const Player = preload("res://scenes/entities/Entity-Player.tscn")

@onready var SunLight: DirectionalLight3D = $DirectionalLight3D

func _ready():
	Networking.add_player_request.connect(add_player)
	Options.changed.connect(toggle_shadows)
	
	Global.play_state_loaded.emit()
	
	toggle_shadows()

func add_player(id):
	var newPlayer = Player.instantiate()
	newPlayer.name = str(id)
	add_child(newPlayer)

func toggle_shadows():
	SunLight.shadow_enabled = Options.shadows

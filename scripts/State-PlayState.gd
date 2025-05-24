extends Node3D

const Player = preload("res://scenes/entities/Entity-Player.tscn")
const Server_Dummy = preload("res://scenes/entities/Entity-Server.tscn")

@onready var SunLight: DirectionalLight3D = $DirectionalLight3D

func _ready():
	Networking.add_player_request.connect(add_player)
	Networking.remove_player_request.connect(remove_player)
	Networking.add_server_request.connect(add_server)
	Global.firin.connect(spawn_bullet)
	Options.changed.connect(toggle_shadows)
	
	Global.play_state_loaded.emit()
	
	toggle_shadows()
		
func remove_player(id):
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()

func add_player(id):
	var newPlayer = Player.instantiate()
	newPlayer.name = str(id)
	newPlayer.add_to_group("players")
	add_child(newPlayer)
	
func add_server(id):	
	var server_dummy = Server_Dummy.instantiate()
	server_dummy.name = str(id)
	add_child(server_dummy)

func toggle_shadows():
	if Options.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func spawn_bullet(projectile):
	add_child(projectile)

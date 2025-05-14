extends Node

signal add_player_request(id, name)
signal remove_player_request(id)
signal add_server_request(id)
signal remove_server_request

var enetPeer = null
var ip = "localhost"

const PORT = 19132

func _ready() -> void:
	multiplayer.peer_disconnected.connect(remove_player)

func host_server():
	enetPeer = ENetMultiplayerPeer.new()
	enetPeer.create_server(PORT)
	multiplayer.multiplayer_peer = enetPeer
	multiplayer.peer_connected.connect(add_player)
	await Global.play_state_loaded
	add_server(multiplayer.get_unique_id())

func join_server():
	enetPeer = ENetMultiplayerPeer.new()
	enetPeer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = enetPeer

func remove_player(id):
	remove_player_request.emit(id)
	if id == 1:
		Global.Player = null
		Global.HUD.visible = false
		get_tree().change_scene_to_file("res://scenes/State-MainMenuState.tscn")
	
func remove_server():
	remove_server_request.emit()

func add_player(id):
	add_player_request.emit(id)
	
func add_server(id):
	add_server_request.emit(id)
	
	

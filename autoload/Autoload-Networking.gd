extends Node

signal add_player_request(id)
signal remove_player_request(id)
signal add_server_request(id)

var enetPeer = ENetMultiplayerPeer.new()
var ip = "localhost"

const PORT = 19132

func host_server():
	enetPeer.create_server(PORT)
	multiplayer.multiplayer_peer = enetPeer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	await Global.play_state_loaded
	add_server(multiplayer.get_unique_id())

func join_server():
	enetPeer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = enetPeer

func remove_player(id):
	remove_player_request.emit(id)

func add_player(id):
	add_player_request.emit(id)
	
func add_server(id):
	add_server_request.emit(id)

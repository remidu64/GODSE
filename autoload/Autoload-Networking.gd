extends Node

signal add_player_request(id)

var enetPeer = ENetMultiplayerPeer.new()

const PORT = 19132

func host_server():
	enetPeer.create_server(PORT)
	multiplayer.multiplayer_peer = enetPeer
	multiplayer.peer_connected.connect(add_player)
	await Global.play_state_loaded
	add_player(multiplayer.get_unique_id())

func join_server():
	enetPeer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enetPeer

func add_player(id):
	add_player_request.emit(id)

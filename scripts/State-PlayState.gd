extends Node3D

const Player = preload("res://scenes/entities/Entity-Player.tscn")
const Bullet = preload("res://scenes/entities/Entity-Bullet.tscn")



@onready var SunLight: DirectionalLight3D = $DirectionalLight3D

var pos = Vector3(1, 0, 0)

func _ready():
	Networking.add_player_request.connect(add_player)
	Networking.remove_player_request.connect(remove_player)
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
	add_child(newPlayer)
	for i in get_tree().get_nodes_in_group("players"):
		i.connect("shooting", spawn_bullet)

func toggle_shadows():
	SunLight.shadow_enabled = Options.shadows
	
func spawn_bullet():	
	add_child(Bullet.instantiate())

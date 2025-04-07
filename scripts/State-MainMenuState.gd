extends Control

@onready var versionLabel: Label = $versionLabel
@onready var serverIP: TextEdit = $VBoxContainer/serverIP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	versionLabel.text = "GODSE v%s" % GameInfo.gameVersion


func _on_join_pressed() -> void:
	Networking.ip = serverIP.text
	Networking.join_server()
	get_tree().change_scene_to_file("res://scenes/State-PlayState.tscn")


func _on_host_pressed() -> void:
	Networking.ip = serverIP.text
	Networking.host_server()
	get_tree().change_scene_to_file("res://scenes/State-PlayState.tscn")

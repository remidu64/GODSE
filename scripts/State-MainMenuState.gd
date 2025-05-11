extends Control

@onready var versionLabel: Label = $MainMenu/versionLabel
@onready var serverIP: TextEdit = $MainMenu/VBoxContainer/serverIP
@onready var username: TextEdit = $MainMenu/VBoxContainer/username
@onready var mainmenu: Control = $MainMenu
@onready var optionsmenu: Control = $OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	versionLabel.text = "GODSE v%s" % GameInfo.gameVersion
	if DisplayServer.get_name() == "headless":
		Networking.ip = "localhost"
		Networking.host_server()
		get_tree().change_scene_to_file("res://scenes/State-PlayState.tscn")
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if optionsmenu.visible:
			optionsmenu.exit_menu()
		mainmenu.visible = not mainmenu.visible
		optionsmenu.visible = not optionsmenu.visible

func _on_join_pressed() -> void:
	Networking.ip = serverIP.text
	Networking.join_server()
	if username.text:
		Global.Name = username.text
	get_tree().change_scene_to_file("res://scenes/State-PlayState.tscn")

func _on_host_pressed() -> void:
	Networking.ip = serverIP.text
	Networking.host_server()
	get_tree().change_scene_to_file("res://scenes/State-PlayState.tscn")
	
func _on_options_pressed() -> void:
	mainmenu.visible = false
	optionsmenu.visible = true

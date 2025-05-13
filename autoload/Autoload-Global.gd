extends Node

signal play_state_loaded
signal player_loaded
signal firin(projectile)
signal hit(shooter, victim, damage)
signal leaving 

@onready var HUD: Control = $Game_HUD
@onready var Health_Bar: Control = $Game_HUD/HealthBar
@onready var Health_Num: Label = $Game_HUD/HealthBar/Health

# player node, set in Entity-Player.gd
var Player = null
var Health = 100.0
var Max_Health = 100.0

# name for the player
var Name = "john GODSE"

func _ready() -> void:
	player_loaded.connect(set_player_name)
	hit.connect(apply_damage)
	
func _physics_process(delta: float) -> void:
	if HUD.visible:
		Health_Bar.bar_size = Health / Max_Health
		Health_Num.text = str(int(Health))
		
func set_player_name():
	Player.player_name = Name
	HUD.visible = true
	
func apply_damage(_shooter, victim, damage):
	if victim == Player:
		Health -= damage

extends Node

signal play_state_loaded
signal player_loaded
signal firin(projectile)
signal hit(shooter, victim, damage)
signal leaving 

@onready var HUD: Control = $Game_HUD
@onready var Health_Bar: Control = $Game_HUD/HealthBar
@onready var Shooting_Bar: Control = $Game_HUD/ShootingTimer

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
		Health_Bar.hp = Health
		Health_Bar.max_hp = Max_Health
		Shooting_Bar.hp = Player.shoot_timer
		Shooting_Bar.max_hp = 1/Player.gun.rps
		
		
func set_player_name():
	Player.player_name = Name
	HUD.visible = true
	
func apply_damage(_shooter, victim, damage):
	if victim == Player:
		Health -= damage

extends Node3D

const ROUGHCUT = preload("res://scenes/gun/Roughcut.tscn")

@onready var gun: MeshInstance3D = $Gun_Mesh

var damage
var spread
var muzzle_velocity
var bullets_per_shot
var recoil
var knockback
var full_auto
var mag_size
var time_to_reload
var ammo_per_reload
var rps

func _ready() -> void:
	var roughcut = ROUGHCUT.instantiate()
	
	gun.mesh = roughcut.mesh
	
	damage = roughcut.damage
	muzzle_velocity = roughcut.muzzle_velocity
	recoil = roughcut.recoil
	bullets_per_shot = roughcut.bullets_per_shot
	knockback = roughcut.knockback
	spread = roughcut.spread
	full_auto = roughcut.full_auto
	mag_size = roughcut.mag_size
	time_to_reload = roughcut.time_to_reload
	ammo_per_reload = roughcut.ammo_per_reload
	rps = roughcut.rpm/60

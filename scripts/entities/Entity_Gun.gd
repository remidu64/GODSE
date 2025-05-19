extends Node3D

const ROUGHCUT = preload("res://scenes/gun/Roughcut.tscn")

@onready var gun: MeshInstance3D = $Gun_Mesh

var damage
var spread
var muzzle_velocity
var bullets_per_shot
var recoil
var knockback

func _ready() -> void:
	var roughcut = ROUGHCUT.instantiate()
	
	gun.mesh = roughcut.mesh
	
	damage = roughcut.damage
	muzzle_velocity = roughcut.muzzle_velocity
	recoil = roughcut.recoil
	bullets_per_shot = roughcut.bullets_per_shot
	knockback = roughcut.knockback
	spread = roughcut.spread

extends Node

var damage: float = 1
var muzzle_velocity: float = 35
var spread: float = 10

var bullets_per_shot: int = 360
var ammo_per_shot: int = 1
var full_auto: bool = true
var rpm: float = 3600

var recoil: float = 0.01
var visual_recoil: float = 0.25
var knockback: float = 2

var mag_size: int = 360
var time_to_reload: float = 1
var ammo_per_reload: int = 10000

var mesh = get_child(0).mesh

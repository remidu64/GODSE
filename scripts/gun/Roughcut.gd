extends Node

var damage: float = 25
var muzzle_velocity: float = 35
var spread: float = 2

var bullets_per_shot: int = 2
var full_auto: bool = false
var rpm: float = 300

var recoil: float = 5
var knockback: float = 2

var mag_size: int =  8
var time_to_reload: float = 1
var ammo_per_reload: int = 1

var mesh = get_child(0).mesh

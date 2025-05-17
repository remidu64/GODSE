extends Node3D

var damage: float
var muzzle_velocity: float
	
var reload_time: float
var mag_size: int
	
var ads_zoom: float
	
var model

func init(_damage: float, _muzzle_velocity: float, _model: PackedScene):
	damage = _damage
	muzzle_velocity = _muzzle_velocity
	model = _model
	return [damage, muzzle_velocity, model]

extends Node3D

const ROUGHCUT = preload("res://scenes/gun/Roughcut.tscn")

@onready var gun: MeshInstance3D = $Gun_Mesh

func _ready() -> void:
	var roughcut = ROUGHCUT.instantiate()
	gun.mesh = roughcut.mesh

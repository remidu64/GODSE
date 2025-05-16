extends Node3D

@onready var mesh: MeshInstance3D = $Gun_Mesh

var vanguard_model = preload("res://assets/model/gun/vanguard/vanguard.glb")

var vanguard = Guns.init(10, 50, vanguard_model)

func _ready() -> void:
	print(vanguard.mesh)
	mesh.mesh = vanguard.mesh

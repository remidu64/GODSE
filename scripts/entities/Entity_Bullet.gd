extends Node3D

@onready var head: RigidBody3D = $Head
@onready var casing: RigidBody3D = $Body

var shooter_name: StringName
var head_velocity: Vector3
var casing_velocity: Vector3

func _ready() -> void:
	add_to_group("bullets")
	head.linear_velocity = head_velocity
	casing.linear_velocity = casing_velocity
	

func _physics_process(delta: float) -> void:
	var bullets = get_tree().get_nodes_in_group("bullets")
	if bullets.size() > 100 and not is_instance_valid(bullets[0].head):
		bullets[0].queue_free()

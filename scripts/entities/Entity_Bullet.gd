extends Node3D

@onready var head: RigidBody3D = $Head
@onready var casing: RigidBody3D = $Body

@export var shooter_name: StringName
@export var starting_velocity: Vector3

func _ready() -> void:
	add_to_group("bullets")
	head.linear_velocity = starting_velocity
	head.set_contact_monitor(true)
	head.set_max_contacts_reported(10)
	casing.linear_velocity = get_global_transform_interpolated().basis.x * 7 + get_global_transform_interpolated().basis.y * 5
	

func _physics_process(delta: float) -> void:
	if get_tree().get_nodes_in_group("bullets").size() > 300:
			get_tree().get_nodes_in_group("bullets")[0].queue_free()
	if is_instance_valid(head):
		for i in head.get_colliding_bodies():
			if i is CharacterBody3D:
				i.health -= 20
				head.queue_free()
			if i.is_in_group("map"):
				head.queue_free()

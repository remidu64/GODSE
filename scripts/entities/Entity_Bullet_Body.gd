extends RigidBody3D

func _ready() -> void:
	add_to_group("bullets")

func _physics_process(delta: float) -> void:
	var casing_group = get_tree().get_nodes_in_group("bullets")
	if casing_group.size() > 100:
		casing_group[0].queue_free()
	if position.y < -100:
		queue_free()
	

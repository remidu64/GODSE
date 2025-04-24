extends RigidBody3D

func _physics_process(delta: float) -> void:
	if position.y < -100:
		queue_free()

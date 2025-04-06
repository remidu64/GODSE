extends Node3D

@onready var gayme: Node3D = $"." 
@onready var camera: Camera3D = $"Camera3D"

var forward: bool = false
var backwards: bool = false
var left: bool = false
var right: bool = false


func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if forward:
		camera.translate(Vector3.FORWARD*0.01)
	if backwards:
		camera.translate(Vector3.BACK*0.01)
	if left:
		camera.translate(Vector3.LEFT*0.01)
	if right:
		camera.translate(Vector3.RIGHT*0.01)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("forward"):
		forward = true
	if event.is_action_released("forward"):
		forward = false
		
	if event.is_action_pressed("backwards"):
		backwards = true
	if event.is_action_released("backwards"):
		backwards = false
		
	if event.is_action_pressed("left"):
		left = true
	if event.is_action_released("left"):
		left = false
		
	if event.is_action_pressed("right"):
		right = true
	if event.is_action_released("right"):
		right = false

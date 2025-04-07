extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera

@onready var optionsHud: CanvasLayer = $OptionsHud
@onready var optionsMenu: Control = $OptionsHud/OptionsMenu

var inOptions = false

const SPEED = 2.5
const JUMP_VELOCITY = 4.5

const SUB_STATE_OPTIONS_MENU = preload("res://scenes/substates/SubState-OptionsMenu.tscn")
# built in godot functions

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Options.changed.connect(reload_options)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * Options.sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * Options.sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !inOptions:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			optionsHud.visible = true
			inOptions = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			optionsHud.visible = false
			optionsMenu.exit_menu()
			reload_options()
			inOptions = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if check_if_can_move():
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("left", "right", "forward", "backwards")
		var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

# custom functions

func check_if_can_move():
	if inOptions:
		return false
	
	return true

func reload_options():
	camera.fov = Options.get_option("FOV")

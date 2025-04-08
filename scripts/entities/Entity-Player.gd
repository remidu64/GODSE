extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera

@onready var optionsHud: CanvasLayer = $OptionsHud
@onready var optionsMenu: Control = $OptionsHud/OptionsMenu

var inOptions = false

# Movement constants
const ACCELERATION = 1.1
const RUNNING_MULTIPLIER = 1.5
const JUMP_VELOCITY = 5.5
const JUMP_SPEED_MULTIPLIER = 1.35
const LATERAL_VELOCITY_COEFFICENT = 0.1 # How much does moving impact how high you jump
const FRICTION = 0.35
const AIR_FRICTION = 0.01


const SUB_STATE_OPTIONS_MENU = preload("res://scenes/substates/SubState-OptionsMenu.tscn")
# built in godot functions

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority():
		return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Options.changed.connect(reload_options)
	camera.current = true
	
	# set the player variable in Global (Autoload-Global.gd)
	Global.Player = self

func _exit_tree() -> void:
	if not is_multiplayer_authority():
		return
	
	# reset the player variable in Global (Autoload-Global.gd) once the player leaves the game
	# (yeah its useless rn)
	Global.Player = null

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * Options.sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * Options.sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if Input.is_action_just_pressed("pause"):
		# might have to rewrite this actually
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
	# And also handle air friction and floor friction
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x *= 1-AIR_FRICTION
		velocity.z *= 1-AIR_FRICTION
	else:
		velocity.x *= 1-FRICTION
		velocity.z *= 1-FRICTION
		
	# Get player movement vector
	var input_dir := Input.get_vector("left", "right", "forward", "backwards")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_just_pressed("run"): # If the player starts running, increase the FOV like what happens in Minecraft
		camera.fov *= 1.1
		
	if Input.is_action_pressed("run"): # Too lazy to propely implement running, so just multiply the direction vector by the running multiplier and call it a day
		direction *= RUNNING_MULTIPLIER
	else:
		reload_options()
	
	if check_if_can_move():
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY * (1 + sqrt(velocity.x**2 + velocity.y**2)*LATERAL_VELOCITY_COEFFICENT) # You jump a bit higher when you move faster
			velocity.x *= JUMP_SPEED_MULTIPLIER
			velocity.z *= JUMP_SPEED_MULTIPLIER
			
		# Change player velocity depending on their acceleration and their movement vector
		if direction and is_on_floor():
			velocity.x += ACCELERATION * direction.x
			velocity.z += ACCELERATION * direction.z
		elif direction:
			velocity.x += ACCELERATION * direction.x * 0.05
			velocity.z += ACCELERATION * direction.z * 0.05
			
	# p h y s i c s
	move_and_slide()

# custom functions

func check_if_can_move():
	if inOptions:
		return false
	
	return true

func reload_options():
	camera.fov = Options.fov

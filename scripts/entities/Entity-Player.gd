extends CharacterBody3D


@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var gun: Node3D = $Head/Camera/Gun
@onready var hudcamera: Node3D = $HUD/SubViewportContainer/SubViewport/HudCamera
@onready var hudgun: Node3D = $HUD/SubViewportContainer/SubViewport/HudCamera/HudGun
@onready var raycast: RayCast3D = $Head/Camera/RayCast3D

@onready var optionsHud: CanvasLayer = $OptionsHud
@onready var optionsMenu: Control = $OptionsHud/OptionsMenu

var inOptions = false

var health: int = 100

# Movement constants
const ACCELERATION: float = 1.1
const RUNNING_MULTIPLIER: float = 1.5
const JUMP_VELOCITY: float = 5.5
const JUMP_SPEED_MULTIPLIER: float = 1.35
const LATERAL_VELOCITY_COEFFICENT: float = 0.05 # How much does moving impact how high you jump
const FRICTION: float = 0.35
const AIR_FRICTION: float = 0.01
const RECOIL: float = 3
var DEFAULTGUNPOS = null


const SUB_STATE_OPTIONS_MENU = preload("res://scenes/substates/SubState-OptionsMenu.tscn")
const BULLET = preload("res://scenes/entities/Entity-Bullet.tscn")

# built in godot functions

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority():
		return
	
	print(str(name).to_int())
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Options.changed.connect(reload_options)
	camera.current = true
	
	raycast.position = camera.position
	raycast.rotation = camera.rotation
	
	# set the player variable in Global (Autoload-Global.gd)
	Global.Player = self
	
	gun.visible = false
	DEFAULTGUNPOS = hudgun.position

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
	
	# shooting
	if Input.is_action_just_pressed("shoot"):
		shoot.rpc()

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		return
	gun.position = lerp(gun.position, Vector3(0, 0, 0), 10.0 * delta)
	gun.rotation = lerp(gun.rotation, Vector3(0, 0, 0), 10.0 * delta)
	if not is_multiplayer_authority():
		return
	hudgun.position = lerp(hudgun.position, DEFAULTGUNPOS, 10.0 * delta)
	hudgun.rotation = lerp(hudgun.rotation, Vector3(0, 0, 0), 10.0 * delta)
	# WARNING: put all gameplay related shit under this line
	
	if position.y < -100:
		health = 0
	
	if health <= 0:
		position = Vector3(randf_range(-10, 10), 1, randi_range(-10, 10))
		print("dead")
		health = 100 	
		
	$HUD/HitMarker.self_modulate = lerp($HUD/HitMarker.self_modulate, Color(1.0, 1.0, 1.0, 0.0), 14.0 * delta)
	
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
	if Input.is_action_pressed("run"): 
		direction *= RUNNING_MULTIPLIER # Too lazy to propely implement running, so just multiply the direction vector by the running multiplier and call it a day
		camera.fov = lerp(camera.fov, float(Options.fov + 10), 7.0 * delta) # If the player starts running, increase the FOV like what happens in Minecraft
	else:
		camera.fov = lerp(camera.fov, float(Options.fov), 7.0 * delta) # Make it go back to normal once the player is no longer running
	
	if check_if_can_move():
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY * (1 + sqrt(velocity.x**2 + velocity.z**2)*LATERAL_VELOCITY_COEFFICENT) # You jump a bit higher when you move faster
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

@rpc("call_local")
func shoot():
	if multiplayer.is_server():
		return
	var coeff_y = remap(raycast.global_rotation.x, -PI/2, PI/2, 1, -1)
	gun.position.z += randf_range(0.25, 0.75)
	gun.position.x += randf_range(-0.1, 0.1)
	gun.rotation.x += randf_range(TAU/16, TAU/12)
	gun.rotation.y += randf_range(-TAU/22, TAU/22)
	hudgun.position.z += randf_range(0.25, 0.75)
	hudgun.position.x += randf_range(-0.1, 0.1)
	hudgun.rotation.x += randf_range(TAU/16, TAU/12)
	hudgun.rotation.y += randf_range(-TAU/22, TAU/22)
	velocity.x += -(abs(coeff_y)-1) * sin(raycast.global_rotation.y) * RECOIL
	velocity.y += coeff_y * RECOIL
	velocity.z += -(abs(coeff_y)-1) * cos(raycast.global_rotation.y) * RECOIL
	var bullet = BULLET.instantiate()
	bullet.position = raycast.global_position - (raycast.get_global_transform_interpolated().basis.z * 2)
	bullet.rotation = raycast.global_rotation
	get_node("/root/gayme").add_child(bullet, true)

func check_if_can_move():
	if inOptions:
		return false
	
	return true

func reload_options():
	camera.fov = Options.fov

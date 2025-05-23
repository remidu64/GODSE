extends CharacterBody3D


@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera
@onready var gun: Node3D = $GunPos/Gun
@onready var gunpos: Node3D = $GunPos
@onready var truegunpos: Node3D = $Head/Camera/TrueGunPos
@onready var raycast: RayCast3D = $Head/Camera/RayCast3D
@onready var nametag: Label3D = $Nametag
@onready var healthtag: Label3D = $Healthtag
@onready var hitmarker: AudioStreamPlayer = $Sounds/hitmarker
@onready var optionsHud: CanvasLayer = $OptionsHud
@onready var optionsMenu: Control = $OptionsHud/OptionsMenu
@onready var fps: Label = $HUD/FPS
@onready var background: Sprite3D = $Healthtag/Healthbarbackground
@onready var hpbar: Sprite3D = $Healthtag/Healthbarbackground/Healthbar

# global variables

var inOptions = false
var guntransform = null
var target_fov = float(Options.fov)
var running = false
var adsing = false
var sensitivity = float(Options.sensitivity)
var regen: float = 3.0/60.0

# gun vars
var shoot_timer: float = 0
var reload_timer: float = 0
var reloading: bool = false
var ammo: int = 0
var missing_shots: float = 0

# synced variables
@export var health: float = 100.0
@export var max_health: float = 100.0
@export var player_name = "john GODSE"


# constants
const ACCELERATION: float = 1.1
const RUNNING_MULTIPLIER: float = 2
const JUMP_VELOCITY: float = 5.5
const JUMP_SPEED_MULTIPLIER: float = 1.35
const LATERAL_VELOCITY_COEFFICENT: float = 0.05 # How much does moving impact how high you jump
const FRICTION: float = 0.35
const AIR_FRICTION: float = 0.01
const TINY_VECTOR = Vector3.LEFT * 0.001
const ADS_ZOOM = 1.5
const RUN_ZOOM = 0.9
var DEFAULT_GUN_POS = null


const SUB_STATE_OPTIONS_MENU = preload("res://scenes/substates/SubState-OptionsMenu.tscn")
const BULLET = preload("res://scenes/entities/Entity-Bullet.tscn")
const GODSE_HIT_SOUND = preload("res://assets/sounds/hitmarkers/godse_hitmarker_v1.ogg")
const MEME_HIT_SOUND = preload("res://assets/sounds/hitmarkers/meme_hitmarker.ogg")

# built in godot functions

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if multiplayer.is_server():
		return
	if not is_multiplayer_authority():
		return
	
	Global.hit.connect(play_hitmarker)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.make_current()
	
	raycast.position = camera.position
	raycast.rotation = camera.rotation
	gunpos.global_transform = truegunpos.global_transform
	
	nametag.visible = false
	healthtag.visible = false
	
	# set the player variable in Global (Autoload-Global.gd)
	Global.Player = self
	
	DEFAULT_GUN_POS = truegunpos.position # gas station sushi
	optionsMenu.change_quit_visibility()
	Options.changed.connect(update_options)
	update_options()
	
	Global.leaving.connect(leave)
	
	ammo = gun.mag_size
	
	Global.player_loaded.emit()
	
func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		return
	
	# CODE HERE RUNS FOR EVERY PLAYER
	var gunangdiff = Vector3(angle_difference(gunpos.global_rotation.x, truegunpos.global_rotation.x), angle_difference(gunpos.global_rotation.y, truegunpos.global_rotation.y), angle_difference(gunpos.global_rotation.z, truegunpos.global_rotation.z))
	gunpos.global_position += velocity.normalized() * -sqrt(velocity.length())/250
	gunpos.global_transform = lerp(gunpos.global_transform, truegunpos.global_transform, (80*gunangdiff.length() + 6) * delta)
	gun.transform = lerp(gun.transform, Transform3D.IDENTITY, 10.0 * delta)
	nametag.text = player_name
	# CODE HERE RUNS FOR EVERY PLAYER
	
	if not is_multiplayer_authority():
		# CODE HERE ONLY RUNS FOR OTHER PLAYERS
		healthtag.text = "%s / %s" % [int(health), int(max_health)]
		hpbar.scale = Vector3(health/max_health, 1, 1)
		# CODE HERE ONLY RUNS FOR OTHER PLAYERS
		return
		
	# CODE BELOW ONLY RUNS FOR CURRENT PLAYER
	
	camera.make_current()
	
	health = Global.Health
	max_health = Global.Max_Health
	
	target_fov = float(Options.fov)
	sensitivity = float(Options.sensitivity)
	if running:
		target_fov /= RUN_ZOOM
	if adsing:
		target_fov /= ADS_ZOOM
		sensitivity = float(Options.sensitivity) / ADS_ZOOM
		
	camera.fov = lerp(camera.fov, target_fov, 15 * delta)
	
	if position.y < -100:
		Global.Health = 0
	
	if Global.Health <= 0:
		position = Vector3(randf_range(-10, 10), 1, randi_range(-10, 10))
		velocity = Vector3.ZERO
		Global.Health = Global.Max_Health	
		
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
			inOptions = false
			
	# zooming
	if Input.is_action_pressed("zoom"):
		adsing = true
	else:
		adsing = false
	
	# Add the gravity.
	# And also handle air friction and floor friction
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x *= (1 - AIR_FRICTION)
		velocity.z *= (1 - AIR_FRICTION)
	else:
		velocity.x *= (1 - FRICTION)
		velocity.z *= (1 - FRICTION)
		
	# Get player movement vector
	var input_dir := Input.get_vector("left", "right", "forward", "backwards")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed("run"): 
		direction *= RUNNING_MULTIPLIER # Too lazy to propely implement running, so just multiply the direction vector by the running multiplier and call it a day
		running = true # If the player starts running, increase the FOV like what happens in Minecraft
	else:
		running = false  # Make it go back to normal once the player is no longer running
	if adsing:
		direction /= ADS_ZOOM
	
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
			
			# shooting
		if Input.is_action_pressed("shoot") and gun.full_auto:
			missing_shots += gun.rps/60
			while ammo > 0 and missing_shots >= 1:
				reloading = false
				shoot()
				missing_shots -= 1
				if ammo <= 0:
					reloading = true
					reload_timer = gun.time_to_reload
			if reload_timer <= 0 and not reloading:
				reloading = true
				reload_timer = gun.time_to_reload
				
		if Input.is_action_just_pressed("shoot") and not gun.full_auto and shoot_timer <= 0:
			if ammo > 0:
				reloading = false
				shoot()
				shoot_timer = 1/gun.rps
				if ammo <= 0:
					reloading = true
					reload_timer = gun.time_to_reload
			if reload_timer <= 0 and not reloading:
				reloading = true
				reload_timer = gun.time_to_reload
			
		if Input.is_action_just_pressed("reload"):
			reload_timer = gun.time_to_reload
			reloading = not reloading
			
			
	if reloading:
		missing_shots = 0
		reload_timer -= delta
		if reload_timer <= 0:
			ammo += gun.ammo_per_reload
			reload_timer = gun.time_to_reload
		if ammo >= gun.mag_size:
			reloading = false
			reload_timer = 0
			ammo = gun.mag_size
		
	Global.Health += regen
	
	if Global.Health > Global.Max_Health:
		Global.Health = Global.Max_Health
		
	if shoot_timer > 0:
		shoot_timer -= delta
	
	fps.text = "%s FPS" % Engine.get_frames_per_second()
	# p h y s i c s
	move_and_slide()

# custom functions


func shoot():
	if multiplayer.is_server():
		return
	var coeff_y = remap(raycast.global_rotation.x, -PI/2, PI/2, 1, -1)
	var RECOIL_MULT = 1
	if adsing:
		RECOIL_MULT = 0.05
	gun.transform = gun.transform.translated(Vector3(randf_range(-0.1, 0.1), randf_range(0.2, 0.4), randf_range(0.25, 0.75))*RECOIL_MULT*gun.visual_recoil)
	gun.transform = gun.transform.rotated(Vector3.RIGHT, randf_range(TAU/16, TAU/12)*RECOIL_MULT*gun.visual_recoil)
	gun.transform = gun.transform.rotated(Vector3.UP, randf_range(-TAU/22, TAU/22)*RECOIL_MULT*gun.visual_recoil)
	velocity.x += -(abs(coeff_y)-1) * sin(raycast.global_rotation.y) * gun.recoil
	velocity.y += coeff_y * gun.recoil
	velocity.z += -(abs(coeff_y)-1) * cos(raycast.global_rotation.y) * gun.recoil
	for i in range(gun.bullets_per_shot):
		if ammo > 0:
			spawn_nullet.rpc(randf_range(0, TAU), randf())
			ammo -= 1
	
@rpc("any_peer", "call_local")
func spawn_nullet(rand1: float, rand2: float): # you do not want to know how much time it fucking took me to figure out bullet spread
	if multiplayer.is_server():
		return
	var bullet = BULLET.instantiate()
	bullet.position = raycast.global_position - (raycast.get_global_transform_interpolated().basis.z * 2)
	bullet.rotation = raycast.global_rotation
	bullet.damage = gun.damage
	bullet.knockback = gun.knockback
	bullet.shooter = self
	bullet.spread = UsefulFunctions.get_spread_dir(bullet.basis, gun.spread, rand1, rand2)
	bullet.start_speed = gun.muzzle_velocity
	Global.firin.emit(bullet)

func check_if_can_move():
	if inOptions:
		return false
	
	return true
	
func play_hitmarker(shooter, _a, _b):
	if self.name == shooter.name:
		hitmarker.play()
		$HUD/HitMarker.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		
func leave():
	if multiplayer.is_server():
		return
	if not is_multiplayer_authority():
		return
	Networking.remove_player(self)
	
func update_options():
	if Options.fps:
		fps.visible = true
	else:
		fps.visible = false
	match Options.get_option("HitmarkerSound"):
		0:
			hitmarker.stream = GODSE_HIT_SOUND
		1:
			hitmarker.stream = MEME_HIT_SOUND

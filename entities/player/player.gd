class_name Player
extends CharacterBody3D

# Signals 
signal is_game_paused(_isPaused)

# Export variables
@export var sensitivity: float = .008

#control
@export var stick_look_sensitivity: float = 2.3
@export var stick_deadzone: float = 0.14     # ignore tiny stick jitter
@export var dpad_rotate_speed: float = 90.0  # deg/sec for rotating held object with D-pad

# Onready variables
@onready var neck:Node3D = $Neck
@onready var camera:Camera3D = $Neck/CameraPlayer
@onready var interaction: RayCast3D = $Neck/CameraPlayer/RayCast3D
@onready var marker: Marker3D = $Neck/CameraPlayer/Marker3D

@onready var joint: Generic6DOFJoint3D = $Neck/CameraPlayer/Generic6DOFJoint3D
@onready var static_body: StaticBody3D = $Neck/CameraPlayer/StaticBody3D

# Player Hand State
@onready var hand_closed : Node3D = $Neck/CameraPlayer/handy_close_project
@onready var hand_open : Node3D = $"Neck/CameraPlayer/handy_project(1)"

# Pause System 
@onready var pause_system: Control = $PauseSystem

# Sound Effects
@onready var consume_object_sound : AudioStreamPlayer = $ConsumeObjectSoundEffect

# Player Movement 
const SPEED: float = 3.0
const JUMP_VELOCITY: float = 4.5
const PULL_FORCE: float = 6.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Objects Interaction
var picked_object: RigidBody3D = null
var rotation_power: float = 0.05
var locked_rotation : bool = false

# TO DO:
# Visualizar los objetos que se pueden interactuar. 


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hand_open.show()
	hand_closed.hide()
	print("Joypads connected: ", Input.get_connected_joypads())

	
func _unhandled_input(event):
	if not locked_rotation and event is InputEventMouseMotion:
		camera_movement(event)
	
	if Input.is_action_pressed("l_click"):
		interact_object()
		hand_open.hide()
		hand_closed.show()
	else:
		remove_picked_object()
		hand_open.show()
		hand_closed.hide()
		
	if Input.is_action_pressed("r_click"):
		locked_rotation = true
		rotate_picked_object(event)
	elif Input.is_action_just_released("r_click"):
		locked_rotation = false
		

func _physics_process(delta):
	# Add the gravity.
	jump(delta)
	movement(delta)
	#highlight_interactable_object()
	pull_picked_object()
	
	move_and_slide()
	if not locked_rotation:
		gamepad_look(delta)              # right-stick look
	rotate_picked_object_with_dpad(delta) # D-pad rotate while grabbing


func movement(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)	
	
func jump(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func camera_movement(event):
	var relative_x = event.relative.x
	var relative_y = event.relative.y
		
	neck.rotate_y(-relative_x * sensitivity)
	camera.rotate_x(-relative_y * sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func interact_object():
	var object_interaction = interaction.get_collider()
	if object_interaction != null and object_interaction is Object_Interact:
		pick_object(object_interaction)
	elif object_interaction != null and object_interaction is Findable_Object:
		consume_object(object_interaction)
		consume_object_sound.play()
	elif object_interaction != null and object_interaction is Drawer:
		object_interaction.drawer_interaction()

func consume_object(object_interaction:Findable_Object):
	object_interaction.consume()

# Pick Up and Drop Logic 
func pick_object(object_interaction:Object_Interact):
	object_interaction = object_interaction as RigidBody3D
	picked_object = object_interaction
	interaction.enabled = false
		
	joint.node_b = picked_object.get_path()

func pull_picked_object():
	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = marker.global_transform.origin
		picked_object.linear_velocity = (b-a)*PULL_FORCE

func remove_picked_object():
	if picked_object != null:
		picked_object = null
		interaction.enabled = true
		
		joint.node_b = joint.get_path()

func rotate_picked_object(event):
	if picked_object != null:
		if event is InputEventMouseMotion:
			static_body.rotate_x(deg_to_rad(event.relative.y * rotation_power))
			static_body.rotate_y(deg_to_rad(event.relative.x * rotation_power))
			
func highlight_interactable_object():
	var object_interaction = interaction.get_collider()
	if object_interaction != null:
		if object_interaction is Findable_Object:
			object_interaction.highlight()


func _on_pause_system_is_game_paused(_isPaused):
	if _isPaused:
		set_physics_process(false)
		set_process_unhandled_input(false)
	else:
		set_physics_process(true)
		set_process_unhandled_input(true)
		
	is_game_paused.emit(_isPaused)
# --- Right stick = camera look ---
func gamepad_look(delta: float) -> void:
	var joy_id := 0  # use first pad; expand to pick another if needed
	var rx := Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_X)
	var ry := Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_Y)

	# deadzone
	if abs(rx) < stick_deadzone: rx = 0.0
	if abs(ry) < stick_deadzone: ry = 0.0

	if rx != 0.0 or ry != 0.0:
		neck.rotate_y(-rx * stick_look_sensitivity * delta)
		camera.rotate_x(-ry * stick_look_sensitivity * delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


# --- D-pad = rotate held object (while grabbing/holding LT) ---
func rotate_picked_object_with_dpad(delta: float) -> void:
	if picked_object == null or not Input.is_action_pressed("l_click"):
		return

	# use your input actions so InputMap decides the device (D-pad / keys)
	var yaw   := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")   # L/R
	var pitch := Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")     # U/D

	if yaw != 0.0:
		static_body.rotate_y(deg_to_rad(yaw * dpad_rotate_speed * delta))
	if pitch != 0.0:
		static_body.rotate_x(deg_to_rad(pitch * dpad_rotate_speed * delta))

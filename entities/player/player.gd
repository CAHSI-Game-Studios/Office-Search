extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var pause = false
@export var sensitivity = .002
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"): #Delete later, debugg purpose only
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
	if event is InputEventMouseMotion:
		var relative_x = event.relative.x
		var relative_y = event.relative.y
		
		neck.rotate_y(-relative_x * sensitivity)
		camera.rotate_x(-relative_y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
		

	
	move_and_slide()

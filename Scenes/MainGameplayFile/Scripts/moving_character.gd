extends CharacterBody3D

@onready var head: Node3D = $head
@onready var standing: CollisionShape3D = $standing
@onready var crouching: CollisionShape3D = $crouching
@onready var ray_cast_3d: RayCast3D = $RayCast3D


var currant_speed = 5.0
const walking_speed = 5.0
const sprint_speed = 8.0
const crouching_speed = 3.0
const JUMP_VELOCITY = 4.5
var lerp_speed = 10
var direction = Vector3.ZERO
var croach_depth = -0.5

const mouse = 0.4

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	crouching.disabled = true ; standing.disabled = false

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle sprint (moved out of the floor check)
	if Input.is_action_pressed("shift"):
		currant_speed=crouching_speed
		head.position.y = lerp(head.position.y, 1.8 + croach_depth, delta*lerp_speed)
		crouching.disabled = false ; standing.disabled = true
	elif !ray_cast_3d.is_colliding():
		crouching.disabled = true ; standing.disabled = false
		head.position.y = lerp(head.position.y, 1.8, delta*lerp_speed)
		
		if Input.is_action_pressed('sprint'):
			currant_speed = sprint_speed
		else:
			currant_speed = walking_speed

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	
	if direction:
		velocity.x = direction.x * currant_speed
		velocity.z = direction.z * currant_speed
	else:
		velocity.x = move_toward(velocity.x, 0, currant_speed)
		velocity.z = move_toward(velocity.z, 0, currant_speed)

	move_and_slide()

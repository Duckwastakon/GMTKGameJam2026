extends CharacterBody3D

@onready var head: Node3D = $head
@onready var standing: CollisionShape3D = $standing
@onready var crouching: CollisionShape3D = $crouching
@onready var ray_cast_3d: RayCast3D = $RayCast3D

@export var item: MeshInstance3D

var bob_time = 0.0
const bob_frequency = 2.0
const bob_amplitude = 0.12
const bob_side_amplitude = 0.05

var currant_speed = 5.0
const walking_speed = 6.0
const sprint_speed = 8.0
const crouching_speed = 3.0
const JUMP_VELOCITY = 4.5
var lerp_speed = 10
var direction = Vector3.ZERO
var croach_depth = -0.5
var external_control = false

const mouse = 0.4
const STEP_HEIGHT = 0.2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	crouching.disabled = true ; standing.disabled = false

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse * (Global.sensitivity / 10) / 5))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse * (Global.sensitivity / 10) / 5))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta: float) -> void:
	if item:
		pass
		#$arrow.visible = item.visible
		#var itemPos: Vector3 = item.global_position
		#var playerPos = self.global_position
		#print(self.rotation)
		#var deltaX = itemPos.x - playerPos.x
		#var deltaZ = itemPos.z - playerPos.z
		
		#var rotationY = atan2(deltaZ, deltaX)
		#var rotationY = Vector2(playerPos.x, playerPos.z).direction_to(Vector2(itemPos.x, itemPos.z)).angle()
		#var rotationY = Vector2(playerPos.x, playerPos.z).angle_to(Vector2(itemPos.x, itemPos.z))
		#$arrow.rotation = Vector3(0, rotationY - self.rotation.y , 0)
	else:
		$arrow.visible = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if external_control:  
		move_and_slide()
		return

	var base_head_y = 1.8
	if Input.is_action_pressed("shift"):
		$sounds/walk.pitch_scale = 0.5
		currant_speed = crouching_speed
		base_head_y = 1.8 + croach_depth
		crouching.disabled = false ; standing.disabled = true
	elif !ray_cast_3d.is_colliding():
		crouching.disabled = true ; standing.disabled = false
		base_head_y = 1.8
		if Input.is_action_pressed('sprint'):
			$sounds/walk.pitch_scale = 2.0
			currant_speed = sprint_speed
		else:
			currant_speed = walking_speed
			$sounds/walk.pitch_scale = 1.3
			
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$sounds/jump.play(0.3)
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
	if direction:
		velocity.x = direction.x * currant_speed
		velocity.z = direction.z * currant_speed
	else:
		velocity.x = move_toward(velocity.x, 0, currant_speed)
		velocity.z = move_toward(velocity.z, 0, currant_speed)
	var is_moving = is_on_floor() and Vector2(velocity.x, velocity.z).length() > 0.5
	if is_moving:
		if not $sounds/walk.playing:
			$sounds/walk.play()
		var speed_ratio = currant_speed / walking_speed
		bob_time += delta * bob_frequency * speed_ratio
		var bob_offset_y = sin(bob_time * TAU) * bob_amplitude
		var bob_offset_x = cos(bob_time * TAU * 0.5) * bob_side_amplitude
		head.position.y = lerp(head.position.y, base_head_y + bob_offset_y, delta * lerp_speed)
		head.position.x = lerp(head.position.x, bob_offset_x, delta * lerp_speed)
	else:
		$sounds/walk.stop()
		bob_time = 0.0
		head.position.y = lerp(head.position.y, base_head_y, delta * lerp_speed)
		head.position.x = lerp(head.position.x, 0.0, delta * lerp_speed)
	try_step_up()
	move_and_slide()

func try_step_up():
	if not is_on_floor():
		return
	var horizontal_velocity = Vector2(velocity.x, velocity.z)
	if horizontal_velocity.length() < 0.1:
		return
	var motion_dir = Vector3(velocity.x, 0, velocity.z).normalized()
	var collision = move_and_collide(motion_dir * 0.1, true)
	if collision:
		global_position.y += STEP_HEIGHT
		var collision_after_step = move_and_collide(motion_dir * 0.1, true)
		if collision_after_step:
			global_position.y -= STEP_HEIGHT

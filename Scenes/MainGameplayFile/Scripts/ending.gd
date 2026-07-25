extends Node3D
@onready var car: RigidBody3D = $car
@onready var camera: Camera3D = $car/Camera3D
@onready var character: CharacterBody3D = $moving_character
@onready var path_follow: PathFollow3D = $car/Path3D/PathFollow3D
@onready var player_camera: Camera3D = $moving_character/head/Camera3D
@onready var one: Area3D = $"Node3envD/house/1"
@onready var two: Area3D = $"Node3envD/house/2"
@onready var three: Area3D = $"Node3envD/house/3"
@onready var five: Area3D = $"Node3envD/house/5"
@onready var six: Area3D = $"Node3envD/house/6"
@onready var four: Area3D = $"Node3envD/house/4"


const Czstart = 503.851; const Czmid = 154.837 ; 
const Czend = -9.186; const Cyend = 74.526 ; const Cr = deg_to_rad(26.0)
const Czspin = -29.002; const Cyspin = 83.787  ; const Crs = deg_to_rad(-26.0) ; const Crsy = deg_to_rad(-180)

func _ready() -> void:
	one.visible = false;two.visible = false;three.visible = false;four.visible = false;five.visible = false;six.visible = false;
	camera.current = true ; car.freeze = true ; character.set_physics_process(false)
	
	car.position = Vector3(0, 0, Czstart)
	car.rotation = Vector3(0, 0, 0)
	camera.position = Vector3(-0.875, 2.795, 4.066)
	camera.rotation = Vector3(deg_to_rad(5), deg_to_rad(180), 0)
	
	var tween = create_tween()
	tween.tween_property(car, "position", Vector3(0, 0, Czmid), 4)
	tween.tween_property(car, "rotation", Vector3(Cr, 0, 0), 1.5)
	tween.tween_property(car, "position", Vector3(0, Cyend, Czend), 3.5)
	tween.tween_property(car, "position", Vector3(0, Cyspin, Czspin), 2)
	tween.parallel().tween_property(car, "rotation", Vector3(Crs, Crsy, 0), 1.5)
	
	var tween2 = create_tween()
	tween2.tween_property(camera, "position", Vector3(-1.534, 2.795, 3.563), 1.5625)
	tween2.tween_property(camera, "position", Vector3(-1.534, 2.795,-0.593), 1.5625)
	tween2.tween_property(camera, "position", Vector3(-1.651, 2.795,-1.479), 1.5625)
	tween2.tween_property(camera, "position", Vector3(0, 2.795,-1.479), 1.5625)
	tween2.tween_property(camera, "position", Vector3(1.651, 2.795,-1.479), 1.5625)
	tween2.tween_property(camera, "position", Vector3(1.534, 2.795,-0.593), 1.5625)
	tween2.tween_property(camera, "position", Vector3(1.534, 2.795, 3.563), 1.5625)
	tween2.tween_property(camera, "position", Vector3(0, 2.795,3.551), 1.5625)
	
	var tween3 = create_tween()
	tween3.tween_property(camera, "rotation", Vector3(deg_to_rad(5), deg_to_rad(135), 0), 1.5625)
	tween3.tween_property(camera, "rotation", Vector3(deg_to_rad(5), deg_to_rad(90), 0), 1.5625)
	tween3.tween_property(camera, "rotation", Vector3(deg_to_rad(5), deg_to_rad(45), 0), 1.5625)
	tween3.tween_property(camera, "rotation", Vector3(deg_to_rad(5), deg_to_rad(0), 0), 1.5625)
	tween3.tween_property(camera, "rotation", Vector3(deg_to_rad(5), deg_to_rad(-45), 0), 1.5625)
	tween3.tween_property(camera, "rotation", Vector3(deg_to_rad(5), deg_to_rad(-90), 0), 1.5625)
	tween3.tween_property(camera, "rotation", Vector3(deg_to_rad(5), deg_to_rad(-135), 0), 1.5625)
	tween3.tween_property(camera, "rotation", Vector3(deg_to_rad(5), deg_to_rad(-180), 0), 1)
	
	roll()
	
	await tween.finished
	player_camera.current = true
	var tween5 = create_tween()
	tween.tween_property(car, "position", Vector3(0, Cyend, Czend), 3.5)
	release_and_fall()


func _process(delta: float) -> void:
	pass
	

func release_and_fall():
	character.external_control = true   
	character.set_physics_process(true)
	
	var start_pos = character.global_position
	var target_pos = Vector3(0.626, 0.5, -121.019)
	var fall_duration = 1.5
	
	character.velocity = launch_to_target(start_pos, target_pos, 0, fall_duration)
	
	var spin_tween = create_tween()
	spin_tween.set_loops()
	spin_tween.tween_property(character, "rotation", character.rotation + Vector3(TAU * 0.3, TAU, TAU * 0.2), 0.6)
	
	while not character.is_on_floor():
		await get_tree().process_frame
	spin_tween.kill()
	
	var stand_tween = create_tween()
	stand_tween.tween_property(character, "rotation", Vector3(0, character.rotation.y, 0), 0.6)
	await stand_tween.finished
	
	character.external_control = false

func launch_to_target(start_pos: Vector3, target_pos: Vector3, arc_height: float, duration: float) -> Vector3:
	var displacement = target_pos - start_pos
	var gravity_y = character.get_gravity().y
	var vertical_velocity = (displacement.y - gravity_y * duration * duration / 2.0) / duration
	var horizontal_velocity = Vector3(displacement.x, 0, displacement.z) / duration
	return horizontal_velocity + Vector3.UP * vertical_velocity


func roll():
	var num = randi_range(1, 6)
	var which = [one, two, three, four, five, six]
	var home = which[num - 1]
	home.visible = true;
	

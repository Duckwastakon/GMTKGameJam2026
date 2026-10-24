extends Node3D
@onready var car: RigidBody3D = $car
@onready var camera: Camera3D = $car/Camera3D
@onready var character: CharacterBody3D = $moving_character
@onready var player_camera: Camera3D = $moving_character/head/Camera3D
@onready var countdown_timer: CanvasLayer = $countdown
@onready var bob: Node3D = $moving_character/Bob
signal stopTimer

const Czstart = 700; 
const Czmid = 0; 

func _ready() -> void:
	$Node3D/Dramatic.play()
	bob.visible = false ; $UI.visible = false; $Info.visible = false
	countdown_timer.countdownFinished.connect(_on_countdown_finished)
	countdown_timer.countdownStarted.connect(_on_countdown_started)
	camera.current = true ; car.freeze = true ; character.set_physics_process(false)
	
	beginnigSpeak()
	
	car.position = Vector3(0, 0, Czstart)
	car.rotation = Vector3(0, 0, 0)
	
	var tween = create_tween()
	tween.tween_property(car, "position", Vector3(0, 0, Czmid), 10)
	
	tween.play()
	
	await tween.finished
	await get_tree().create_timer(1).timeout
	
	player_camera.current = true
	release()

func _on_countdown_finished():
	bob.visible = true
	$Node3D/Dramatic.stop()
	$Node3D/Dramaticbob.play()
	$UI/DigitalBox/DigitalBox2/Who.text = "Bob"
	$UI/DigitalBox/DialogText.text = "If you dont want to go home, lets play"
	$UI.visible = true
	await get_tree().create_timer(2).timeout
	TransitionController.ChangeScene("res://storyAndMenu/endScreen.tscn")
	
func _on_countdown_started():
	$Node3D/heart.play()

func beginnigSpeak():
	$UI/DigitalBox/DigitalBox2/Who.text = "BOB"
	$UI/DigitalBox/DialogText.text = "OK, ok, fine, we are almost there... time to let you go"
	$Info/info/InfoText.text = "Bob is about to drop you off, but who says he wont try to find you"
	$UI.visible = true
	await get_tree().create_timer(2.5).timeout
	$Info.visible = true
	$UI.visible = false
	await get_tree().create_timer(2.6).timeout
	$Info/info/InfoText.text = "When Bob drops you off, you'll only have a few seconds to find your home"
	await get_tree().create_timer(2.6).timeout
	$Info/info/InfoText.text = "Either you find your home or Bob finds you"
	await get_tree().create_timer(2.0).timeout
	$Info/info/InfoText.text = "Run by pressing Shift and find the yellow indicator"
	await get_tree().create_timer(3.0).timeout
	$Info.visible = false

func release():
	character.external_control = true   
	character.set_physics_process(true)
	
	var start_pos = character.global_position
	var target_pos = Vector3(-8, 0, 0)
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

func finnish():
	$enterHouse/CollisionShape3D.disabled = true
	$Node3D/Coin.play()
	await get_tree().create_timer(0.8).timeout
	TransitionController.ChangeScene("res://storyAndMenu/endScreen.tscn")


func _on_enter_house_area_entered(area: Area3D) -> void:
	finnish()

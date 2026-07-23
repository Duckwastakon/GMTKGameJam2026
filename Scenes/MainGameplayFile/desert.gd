extends Node3D
@onready var area: Area3D = $interact_area_ticket
@onready var prompt: Label3D = $interact_area_ticket/Label3D
@onready var digital_box: Panel = $UI/DigitalBox
@onready var dialog_text: Label = $UI/DigitalBox/DialogText  # adjust path to match your actual Label
@onready var who: Label = $UI/DigitalBox/ColorRect/Who
@onready var marker: MeshInstance3D = $here
@onready var wheel: Label3D = $wheel/Area3D/wheel
@onready var wheel_collision: CollisionShape3D = $wheel/Area3D/wheel_collision



var player_in_range = false
var marker_time = 0.0
var marker_base_y = 0.0
var at_ticket = true
var at_wheel = false
var used_ticket = false
var used_wheel = false
var ticket_time = true
var spin_time = false

func _ready() -> void:
	marker.position.x =  -14 ; marker.position.y = 3.129 ; marker.position.z = -7.055
	
	who.text = "Me"
	digital_box.visible = false
	marker.visible = false
	marker_base_y = marker.position.y
	wheel.visible = false
	
	await get_tree().create_timer(2.0).timeout
	dialog_text.text = "Its getting late..I hope the busses still run. I have to get home"
	digital_box.visible = true
	marker.visible = true
	await get_tree().create_timer(4.5).timeout
	digital_box.visible = false
	prompt.visible = false
	prompt.text = "Press E to interact"
	digital_box.visible = false

func _process(delta):
	marker_time += delta
	marker.position.y = marker_base_y + sin(marker_time * 2.0) * 0.3
	marker.rotate_y(delta * 1.0)
	
	if not used_ticket:
		if player_in_range and Input.is_action_just_pressed('interract') and ticket_time == true:
			marker.position.x = -5.897; marker.position.y = 2.967; marker.position.z = 17.508
			prompt.visible = false
			dialog_text.text = "Shoot.. I'm missing 10 bucks.. maybe I should look around"
			digital_box.visible = true
			await get_tree().create_timer(3.0).timeout
			digital_box.visible = false
			used_ticket = true
			spin_time = true ; ticket_time = false
			# removed: prompt.visible = true — ticket is used now, no need to bring prompt back
	
	if at_wheel and not used_wheel and spin_time == true:
		if Input.is_action_just_pressed('interract'):
			marker.visible = false
			wheel.visible = false
			dialog_text.text = "Wait..Damn it, it ate my coins!"
			digital_box.visible = true
			await get_tree().create_timer(2.5).timeout
			dialog_text.text = "Shoot! How the hell am i to get home now?"
			await get_tree().create_timer(3.0).timeout
			digital_box.visible = false
			used_wheel = true
			# removed: prompt.visible = true — wheel is used now too

func _on_body_entered(body: Node3D) -> void:
	if body.name == "moving_character":
		player_in_range = true
		if not used_ticket:
			prompt.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "moving_character":
		player_in_range = false
		prompt.visible = false

func _on_body_entered_3d(body: Node3D) -> void:
	if body.name == "moving_character":
		at_wheel = true
		if spin_time:
			wheel.visible = true

func _on_area_exited_3d(body: Node3D) -> void:
	if body.name == "moving_character":
		wheel.visible = false
		at_wheel = false

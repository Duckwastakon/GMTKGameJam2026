extends Node3D
@onready var digital_box: Panel = $UI/DigitalBox
@onready var dialog_text: Label = $UI/DigitalBox/DialogText
@onready var who: Label = $UI/DigitalBox/DigitalBox2/Who
@onready var car: Area3D = $Area3D
@onready var bobnpc: Node3D = $Bob
@onready var info: CanvasLayer = $Info

func _ready() -> void:
	bobnpc.visible = false
	car.position.x =  -9.573 ; car.position.y = 0.073 ; car.position.z = -55.447
	bobnpc.position.x =  -9.501 ; bobnpc.position.y = 0.236 ; bobnpc.position.z = 8.006
	car.visible = false
	
	$Info/info/InfoText.text = 'press Shift to run & Ctrl to crouch..'
	info.visible = true
	
	who.text = "Me"
	digital_box.visible = false
	
	await get_tree().create_timer(1.0).timeout
	dialog_text.text = "Its getting late.. And I do not have enough for a bus home"
	digital_box.visible = true
	await get_tree().create_timer(4.5).timeout
	digital_box.visible = false
	bob()

func bob():
	car.visible = true
	var tween = create_tween()
	tween.tween_property(car, "position", Vector3( -9.573,0.073, 8.553), 2)
	await get_tree().create_timer(2).timeout
	bobnpc.visible = true
	var tween2 = create_tween()
	$sounds/beep.play()
	tween2.tween_property(bobnpc, "position", Vector3( -6.225,0.175, 8.364), 1)
	who.text = "???"
	dialog_text.text = "Why hello there."
	digital_box.visible = true
	await get_tree().create_timer(2).timeout
	dialog_text.text = "You need a ride? Hop in and lets play a game."
	await get_tree().create_timer(4.5).timeout
	who.text = "Bob"
	dialog_text.text = "I'm Bob, by the way"
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://gameplay/gameplay.tscn")

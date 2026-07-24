extends Node3D

@onready var dialog_text: Label = $UI/DigitalBox/DialogText
@onready var digital_box: Panel = $UI/DigitalBox
@onready var who: Label = $UI/DigitalBox/ColorRect/Who
@onready var ui: CanvasLayer = $UI
@onready var info: Panel = $Info/info
@onready var black_rect: ColorRect = $black/ColorRect
@onready var character: CharacterBody3D = $moving_character
@onready var shop_camera: Camera3D = $Dobbo/ShopCamera
@onready var shop_ui: CanvasLayer = $shopUi
@onready var player_camera: Camera3D = $head/Camera3D

var entering = false ; var has_entered = false;
var inside = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_camera.current = true 
	black_rect.modulate.a = 0.0
	black_rect.visible = false
	character.position.x = 4; character.position.y = 0.5; character.position.z = 10; 
	info.visible = false
	ui.visible = false
	await get_tree().create_timer(1.0).timeout
	who.text = "Bob"
	dialog_text.text = "We need to tank up. Go on in and take your time"
	ui.visible = true
	info.visible = false
	await get_tree().create_timer(3.5).timeout
	dialog_text.text = "Feel free to spend your money as you wish ;)"
	await get_tree().create_timer(2.5).timeout
	ui.visible = false
	inside = true

var q =0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_entered == false and entering == true:
		if Input.is_action_just_pressed('interract'):
			info.visible = false ; inside = true ; has_entered = true
			await fade_to_black()
			character.position.x = 0.3; character.position.y = 0.65; character.position.z = 3.4
			await fade_from_black()
			
	if can_buy == true:
		if Input.is_action_just_pressed('Q') and q == 0:
			shop_camera.current = true  # switches active camera
			character.set_physics_process(false)  # freeze player movement
			#generate_random_items()  # pick 3 items from your item pool
			shop_ui.visible = true
			q = 1
		elif Input.is_action_just_pressed('Q') and q == 1:
			q=0
			player_camera.current = true  # switch back
			character.set_physics_process(true)
			shop_ui.visible = false
			
func _on_door_body_entered(body: Node3D) -> void:
	if has_entered == false:
		if body.name == "moving_character":
			$Info/info/InfoText.text = "press e to enter the shop"
			info.visible = true
			entering = true
func _on_door_body_exited(body: Node3D) -> void:
	if body.name == "moving_character":
		$Info/info/InfoText.text = ""
		info.visible = false
		entering = false

func fade_to_black():
	black_rect.visible = true
	var tween = create_tween()
	tween.tween_property(black_rect, "modulate:a", 1.0, 1.0)
	await tween.finished

func fade_from_black():
	var tween = create_tween()
	tween.tween_property(black_rect, "modulate:a", 0.0, 1.0)
	await tween.finished
	black_rect.visible = false

var first= true;
var can_buy = false
func _on_dobbo_body_entered(body: Node3D) -> void:
	if body.name == "moving_character" and first == true:
		who.text = "Dobbo"
		dialog_text.text = "Hey.. just buy something or leave.."
		ui.visible = true
		await get_tree().create_timer(2.5).timeout
		ui.visible = false
		info.text = 'Use this time to prepare for the next game'
		info.visivle = true
		await get_tree().create_timer(2.5).timeout
		info.text = 'See if Dobbo has anything of use to you'
		await get_tree().create_timer(2.5).timeout
		can_buy = true;

func _on_dobbo_body_exited(body: Node3D) -> void:
	if body.name == "moving_character":
		can_buy = false;

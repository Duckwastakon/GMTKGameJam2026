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
@onready var player_camera: Camera3D = $moving_character/head/Camera3D
@onready var choice: CanvasLayer = $Choice
@onready var dobbo: Area3D = $Dobbo

var entering = false
var has_entered = false
var inside = false
var q = 0
var firsttime = true
var first = true
var can_buy = false
var has_opened_shop = false
var intro_playing = false
var hovering1 = false ; var hovering2 = false; var hovering3 = false
var back = false; var waiting_for_choice = false
var ready_complete = false

func _ready() -> void:
	ui.visible = false
	$"interiors/1".visible = false; $"interiors/2".visible = false; $"interiors/3".visible = false
	set_interior_collision($"interiors/1", true)
	set_interior_collision($"interiors/2", true)
	set_interior_collision($"interiors/3", true)
	roll()
	choice.visible = false
	
	var slots = [$constant/one/Name, $constant/two/Name, $constant/three/Name]
	for i in range(slots.size()):
		if i < Global.boughtItems.size():
			slots[i].text = Global.boughtItems[i]
			slots[i].visible = true
		else:
			slots[i].text = ""

	$constant/Label.text = "Money : " + str(Global.cash)
	$shopUi/First/gold.visible = false; $shopUi/Second/gold.visible = false; $shopUi/Thrid/gold.visible = false
	$shopUi/First/Description.visible = false; $shopUi/Second/Description.visible = false; $shopUi/Thrid/Description.visible = false
	var todays_items = Global.roll("shop_1")
	update_shop_ui(todays_items)
	shop_ui.visible = false
	player_camera.current = true
	black_rect.modulate.a = 0.0
	black_rect.visible = false
	character.position.x = 4; character.position.y = 0.5; character.position.z = 10
	info.visible = false
	await get_tree().create_timer(1.0).timeout
	who.text = "Bob"
	var type = ["Gotta fuel up! Head on into the store.", "I head that store had some human candy~", "Tank up time! Time to get ready for the next game",
	"Eager to leave much! Oh, well, I'll be waiting!", "Go on, go on, friendo", "buddy, pal, partner, go stretch you rlegs for a bit."]
	var num = randi_range(1, 6)
	var text = type[num - 1]
	ui.visible = true
	await typewriter_text(dialog_text, text)
	info.visible = false
	await get_tree().create_timer(3.5).timeout
	await typewriter_text(dialog_text, "Feel free to spend your money as you wish ;)")
	await get_tree().create_timer(2.5).timeout
	ui.visible = false
	ready_complete = true

func set_interior_collision(interior_node: Node, disabled: bool):
	for child in interior_node.get_children():
		if child is CollisionShape3D:
			child.disabled = disabled
		set_interior_collision(child, disabled)

func update_shop_ui(item_list: Array[Dictionary]):
	if item_list.size() > 0:
		$shopUi/First/LabelFirst.text = item_list[0]["name"]
		$shopUi/First/Description.text = item_list[0]["description"]
		$shopUi/First/LabelFirst/Price.text = str(item_list[0]["price"])
	if item_list.size() > 1:
		$shopUi/Second/LabelSecond.text = item_list[1]["name"]
		$shopUi/Second/Description.text = item_list[1]["description"]
		$shopUi/Second/LabelSecond/Price.text = str(item_list[1]["price"])
	if item_list.size() > 2:
		$shopUi/Thrid/LabelThird.text = item_list[2]["name"]
		$shopUi/Thrid/Description.text = item_list[2]["description"]
		$shopUi/Thrid/LabelThird/Price.text = str(item_list[2]["price"])

func _process(delta: float) -> void:
	
	if shop_ui.visible == true:
		ui.visible = false
		info.visible = false
	
	if has_entered == false and entering == true:
		if inside == false:
			if Input.is_action_just_pressed('interract'):
				info.visible = false; inside = true; has_entered = true
				await fade_to_black()
				character.position.x = 0.3; character.position.y = 0.65; character.position.z = 3.4
				await fade_from_black()
				
	if back == true and inside == true:
		info.visible = true
		$Info/info/InfoText.text = 'Press E to leave'
		if Input.is_action_just_pressed('interract'):
			info.visible = false; inside = false; has_entered = false
			await fade_to_black()
			character.position.x = 0.3; character.position.y = 0.5; character.position.z = 5.3
			await fade_from_black()
			who.text = "Bob"
			await typewriter_text(dialog_text, "Suppose you ready to go, ya?")
			ui.visible = true
			info.visible = false
			choice.visible = true
			character.set_physics_process(false)
			waiting_for_choice = true  # now check Yes/No every subsequent frame

	if waiting_for_choice:
		if Input.is_action_just_pressed('Yes'):
			waiting_for_choice = false
			await typewriter_text(dialog_text, "then lets go, friend!")
			await get_tree().create_timer(1.5).timeout
			get_tree().quit()
		elif Input.is_action_just_pressed('No'):
			waiting_for_choice = false
			await typewriter_text(dialog_text, "Then go back in, geez..")
			await get_tree().create_timer(1.0).timeout
			await fade_to_black()
			character.position.x = 0.3; character.position.y = 0.65; character.position.z = 3.4
			await fade_from_black()
			character.set_physics_process(true)
			choice.visible = false; ui.visible = false; inside = true ; has_entered = true

	if can_buy == true and not has_opened_shop and not intro_playing:
		info.visible = true
		$Info/info/InfoText.text = 'Press Q to look at his stock'

	if ui.visible == true:
		$constant/one.visible = false; $constant/two.visible = false; $constant/three.visible = false
	else: $constant/one.visible = true; $constant/two.visible = true; $constant/three.visible = true
		
	if can_buy == true:
		if Input.is_action_just_pressed('Q') and q == 0:
			shop_ui.visible = true
			shop_camera.current = true
			character.set_physics_process(false)
			has_opened_shop = true
			info.visible = false
			q = 1
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.is_action_just_pressed('Q') and q == 1:
			shop_ui.visible = false
			q = 0
			player_camera.current = true
			character.set_physics_process(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if hovering1 == true:
		$shopUi/First/gold.visible = true ;$shopUi/First/Description.visible = true
	else: $shopUi/First/gold.visible = false ;$shopUi/First/Description.visible = false
	
	if hovering2 == true:
		$shopUi/Second/gold.visible = true ;$shopUi/Second/Description.visible = true
	else: $shopUi/Second/gold.visible = false ;$shopUi/Second/Description.visible = false
	
	if hovering3 == true:
		$shopUi/Thrid/gold.visible = true ;$shopUi/Thrid/Description.visible = true
	else: $shopUi/Thrid/gold.visible = false ;$shopUi/Thrid/Description.visible = false

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

func _on_dobbo_body_entered(body: Node3D) -> void:
	if body.name == "moving_character":
		can_buy = true
		if first == true:
			first = false
			intro_playing = true
			who.text = "Dobbo"
			var type = ["Hey.. just buy something or leave..", "You gonna keep coming here or what?", "Just pick something and go..",
			"Hey.. just buy something or leave..", "Welcome to sharop-shop..i guess", "What you lookin' at? Buy or leave."]
			var num = randi_range(1, 6)
			var text = type[num - 1]
			ui.visible = true
			await typewriter_text(dialog_text, text)
			await get_tree().create_timer(2.5).timeout
			ui.visible = false
			await infoAdd()
			intro_playing = false
func infoAdd():
	info.visible = true
	$Info.visible = true
	$Info/info/InfoText.text = 'Use this time to prepare for the next game'
	await get_tree().create_timer(2.5).timeout
	$Info/info/InfoText.text = 'See if Dobbo has anything of use to you'
	await get_tree().create_timer(2.5).timeout
	show_q_reminder()
func show_q_reminder():
	if not has_opened_shop:
		info.visible = true
		$Info/info/InfoText.text = 'Press Q to look at his stock'
func _on_dobbo_body_exited(body: Node3D) -> void:
	if body.name == "moving_character":
		can_buy = false
		if not has_opened_shop:
			info.visible = false
			

func _on_first_mouse_entered() -> void:
	hovering1 = true
func _on_first_mouse_exited() -> void:
	hovering1 = false
func _on_second_mouse_entered() -> void:
	hovering2 = true
func _on_second_mouse_exited() -> void:
	hovering2 = false
func _on_thrid_mouse_entered() -> void:
	hovering3 = true
func _on_thrid_mouse_exited() -> void:
	hovering3 = false

func _on_texture_button_pressed() -> void:
	var price = int($shopUi/First/LabelFirst/Price.text)
	var item_name = $shopUi/First/LabelFirst.text
	buy_item(price, item_name, $shopUi/First/LabelFirst, $shopUi/First/LabelFirst/Price, $shopUi/First/Description)
func _on_texture_button_pressed2() -> void:
	var price = int($shopUi/Second/LabelSecond/Price.text)
	var item_name = $shopUi/Second/LabelSecond.text
	buy_item(price, item_name, $shopUi/Second/LabelSecond, $shopUi/Second/LabelSecond/Price, $shopUi/Second/Description)
func _on_texture_button_pressed3() -> void:
	var price = int($shopUi/Thrid/LabelThird/Price.text)
	var item_name = $shopUi/Thrid/LabelThird.text
	buy_item(price, item_name, $shopUi/Thrid/LabelThird, $shopUi/Thrid/LabelThird/Price, $shopUi/Thrid/Description)

func buy_item(price: int, item_name: String, label_node: Label, price_node: Label, description_node: Label) -> void:
	if Global.boughtItems.size() >= 3:
		print("Backpack full!")
		$Info/info/InfoText.text = 'Your inventory is full. you are unable to own more than 3 items'
		info.visible = true
		await get_tree().create_timer(3).timeout
		info.visible = false
		return

	if not Global.compareCash(price):
		print("Not enough money!")
		$Info/info/InfoText.text = 'You do not have enough money to purchase this'
		info.visible = true
		await get_tree().create_timer(3).timeout
		info.visible = false
		return

	$sounds/coin.play()
	var slots = [$constant/one/Name, $constant/two/Name, $constant/three/Name]
	for slot in slots:
		if slot.text == "":
			slot.visible = true
			slot.text = item_name
			break

	label_node.text = ""
	price_node.text = ""
	description_node.text = ""

	Global.boughtItems.append(item_name)
	Global.cash -= price
	$constant/Label.text = "Money : " + str(Global.cash)

func _on_leave_body_enteredLeave(body: Node3D) -> void:
	back = true;
	$Info.visible = true
func _on_leave_body_exitedLeave(body: Node3D) -> void:
	back = false
	$Info.visible = false

func roll():
	var num = randi_range(1, 3)
	if num == 1:
		$"interiors/1".visible = true
		set_interior_collision($"interiors/1", false)
		dobbo.position.x = 0; dobbo.position.y = 0; dobbo.position.z = 0
		dobbo.rotation.x = deg_to_rad(0); dobbo.rotation.y = deg_to_rad(0); dobbo.rotation.z = deg_to_rad(0)
	elif num == 2:
		$"interiors/2".visible = true
		set_interior_collision($"interiors/2", false)
		dobbo.position.x = 0.925; dobbo.position.y = -0.025; dobbo.position.z = 5.067
		dobbo.rotation.x = deg_to_rad(0); dobbo.rotation.y = deg_to_rad(-92.4); dobbo.rotation.z = deg_to_rad(0)
	else:
		$"interiors/3".visible = true
		set_interior_collision($"interiors/3", false)
		dobbo.position.x = 1.582; dobbo.position.y = 0.18; dobbo.position.z = 5.536
		dobbo.rotation.x = deg_to_rad(2.1); dobbo.rotation.y = deg_to_rad(-126.2); dobbo.rotation.z = deg_to_rad(2.8)

func _on_enter_body_enteredupstairs(body: Node3D) -> void:
	if not ready_complete:
		return
	who.text = "Dobbo(?)"
	var type = ["...", "..and who are you?"]
	var num = randi_range(1, 2)
	var text = type[num - 1]
	await typewriter_text(dialog_text, text)
	ui.visible = true
	await get_tree().create_timer(2.5).timeout
	ui.visible = false
func _on_enter_body_exitedupstairs(body: Node3D) -> void:
	ui.visible = false
	
func typewriter_text(label: Label, full_text: String, duration: float = 1.0):
	label.text = full_text
	label.visible_characters = 0
	var tween = create_tween()
	tween.tween_property(label, "visible_characters", full_text.length(), duration)
	await tween.finished

extends StaticBody3D

signal showCard
signal destroyCard
signal cheat

var savedMaterial: StandardMaterial3D
var savedOutline: ShaderMaterial

var hoverShader = load("res://Scenes/MainGameplayFile/ChildScenes/outlineShader.gdshader")

var hidden = false
var showing = false
var distracted = false
var currentCard

var lastItem: String

var hovering = false

func _ready() -> void:
	connect("cheat", clickedCard)

func setDistracted(val: bool):
	distracted = val
	if val:
		if hovering:
			setNormalHover()
		else:
			setCheatHover()
	else:
		if hovering:
			setNormalHover()
		else:
			setHidden()
	if showing and !val and hidden:
		showing=false
		while(self.rotation_degrees != Vector3(-45-180,0, 0) and !showing):
			rotation_degrees = lerp(rotation_degrees, Vector3(-45-180,0, 0), 0.25)
			await get_tree().create_timer(0.02).timeout
	
	updateText("", false)

func setCard(card: MeshInstance3D, hid: bool):
	add_child(card)
	card.position = Vector3.ZERO
	var newShaderMaterial = ShaderMaterial.new()
	newShaderMaterial.shader = hoverShader
	newShaderMaterial.set_shader_parameter("outline_color", Color.WHITE)
	newShaderMaterial.set_shader_parameter("outline_width", 1)
	var newMaterial = StandardMaterial3D.new()
	newMaterial.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	newMaterial.albedo_color.a = 0.2
	newShaderMaterial.next_pass = newMaterial
	
	savedMaterial = newMaterial
	savedOutline = newShaderMaterial
	
	currentCard = card
	
	if hid:
		hidden = true
		rotation_degrees = Vector3(-45-180,0, 0)
		await showCard
		showing = true
		hidden = false
		var newTween = create_tween()
		newTween.tween_property(self, "rotation_degrees", Vector3(-45,0,0), 0.5)
		newTween.play()
	else:
		rotation_degrees = Vector3(90,0,0)
		var newTween = create_tween()
		newTween.tween_property(self, "rotation_degrees", Vector3(-45,0,0), 0.5)
		newTween.play()

func clickedCard(event):
	if !distracted: return
	
	if event.pressed:
		if hidden:
			showing = true
			while(showing and hidden and distracted):
				rotation_degrees = lerp(rotation_degrees, Vector3(-45,0,0), 0.25)
				await get_tree().create_timer(0.02).timeout
		else:
			destroyCard.emit()
	else:
		if showing and hidden: 
			showing = false
			while(self.rotation_degrees != Vector3(-45-180,0, 0) and !showing and hidden and distracted):
				rotation_degrees = lerp(rotation_degrees, Vector3(-45-180,0, 0), 0.25)
				await get_tree().create_timer(0.02).timeout

func updateText(itemName: String, item:bool = true):
	if item:
		lastItem = itemName
	if itemName != "" and !distracted:
		$Label3D.text = "use " + itemName
		lastItem = itemName
	else:
		if distracted:
			if hidden:
				$Label3D.text = "peek card"
			else:
				$Label3D.text = "replace card"
		else:
			if lastItem != "":
				$Label3D.text = "use " + lastItem
			else:
				$Label3D.text = ""

func _on_mouse_exited() -> void:
	$Label3D.visible = false
	if currentCard:
		currentCard.material_overlay = null
		if(distracted):
			setCheatHover()
		else:
			setHidden()
	if showing: 
		showing = false
		while(self.rotation_degrees != Vector3(-45-180,0, 0) and !showing):
			rotation_degrees = lerp(rotation_degrees, Vector3(-45-180,0, 0), 0.25)
			await get_tree().create_timer(0.02).timeout

func _on_mouse_entered() -> void:
	$Label3D.visible = true
	if currentCard:
		setNormalHover()
		currentCard.material_overlay = savedOutline

func setCheatHover():
	if get_tree().current_scene.canDraw == false: return
	savedMaterial.albedo_color = Color(1, 0, 0, 0.2)
	currentCard.material_overlay = savedOutline

func setNormalHover():
	savedMaterial.albedo_color = Color(1, 1, 1, 0.2)
	currentCard.material_overlay = savedOutline

func setHidden():
	currentCard.material_overlay = null

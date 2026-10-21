extends StaticBody3D

var savedMaterial: StandardMaterial3D
var savedOutline: ShaderMaterial

var hoverShader = load("res://Scenes/MainGameplayFile/ChildScenes/outlineShader.gdshader")

@onready var currentCard: MeshInstance3D = $cardMesh

var goalPosition = Vector3.ZERO
var hovering = false

var price = 0
var cardInfo = null
var cardId = 0

func setCard(id):
	cardId = id
	cardInfo = Global.powerId[id]
	price = cardInfo["price"]
	$cardPrice.text = str(price) + "$"
	$cardInfo.text = cardInfo["txt"]
	var newSurface = StandardMaterial3D.new()
	newSurface.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	newSurface.albedo_texture = load(cardInfo["img"])
	currentCard.set_surface_override_material(0, newSurface)
	
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
	
	rotation_degrees = Vector3(90,0,0)
	var newTween = create_tween()
	newTween.tween_property(self, "rotation_degrees", Vector3(0,0,0), 0.5)
	newTween.play()

var moving = false

func setPos(newPos):
	goalPosition = newPos
	
	if(hovering):
		goalPosition += Vector3(0, 0.02, 0.011)
	
	if !moving:
		moving = true
		while(self.position != goalPosition):
			position = lerp(position, goalPosition, 0.25)
			await get_tree().create_timer(0.01).timeout
		moving = false
	pass

func changePos(newPos):
	goalPosition = newPos
	
	if !moving:
		moving = true
		while(self.position != goalPosition):
			position = lerp(position, goalPosition, 0.25)
			await get_tree().create_timer(0.01).timeout
		moving = false
	pass

func _on_mouse_exited() -> void:
	$Label3D.visible = false
	$cardInfo.visible = false
	$cardPrice.visible = false
	
	if currentCard:
		changePos(goalPosition - Vector3(0, 0.02, 0.011))
		hovering = false

func _on_mouse_entered() -> void:
	$Label3D.visible = true
	$cardInfo.visible = true
	$cardPrice.visible = true
	if currentCard:
		changePos(goalPosition + Vector3(0, 0.02, 0.011))
		hovering = true

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		buyCard()

func buyCard():
	if !get_parent().get_parent().buyCard(price, self, cardId):
		pulse()
		return
	$CollisionShape3D.disabled = true
	
	rotation_degrees += Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5))
	scale *= randf_range(1.5, 2)
	
	for i in randi_range(2, 4):
		var newParticles: CPUParticles3D = $activatedParticles.duplicate()
		add_child(newParticles)
		newParticles.material_override.albedo_color = Color(1,1,1,1)
		newParticles.emitting = true
	
	var scaleTween = create_tween()
	scaleTween.tween_property(self, "scale", Vector3.ZERO, 0.15)
	scaleTween.play()
	
	await get_tree().create_timer(1).timeout
	
	queue_free()

var returningToPos = false
var backToNormalSpeed = 0.25

func pulse():
	rotation_degrees += Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5))
	scale *= randf_range(1.1, 1.25)
	if (!returningToPos):
		returningToPos = true
		while(returningToPos):
			scale = lerp(scale, Vector3.ONE, backToNormalSpeed)
			rotation_degrees = lerp(rotation_degrees, Vector3(0, 0, 0), backToNormalSpeed / 2)
			if rotation_degrees == Vector3.ZERO and scale == Vector3.ONE:
				returningToPos = false
			else:
				await get_tree().create_timer(0.02).timeout

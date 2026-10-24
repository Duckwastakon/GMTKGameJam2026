extends StaticBody3D

var savedMaterial: StandardMaterial3D
var savedOutline: ShaderMaterial

var hoverShader = load("res://shaders/outlineShader.gdshader")

var currentCard

var goalPosition = Vector3.ZERO
var selected = false
var values = null
var hovering = false

func setCard(gottenCard: MeshInstance3D, newValues):
	var card = gottenCard.duplicate()
	add_child(card)
	values = newValues
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
	rotation_degrees = Vector3(90,0,0)
	var newTween = create_tween()
	newTween.tween_property(self, "rotation_degrees", Vector3(0,0,0), 0.5)
	newTween.play()

var moving = false

func setPos(newPos):
	goalPosition = newPos
	
	if(hovering):
		goalPosition += Vector3(0, 0.02, 0.011)
	if(selected):
		goalPosition += Vector3(0, 0.05, 0.01)
	
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
	if currentCard:
		currentCard.material_overlay = null
		changePos(goalPosition - Vector3(0, 0.02, 0.011))
		hovering = false

func _on_mouse_entered() -> void:
	$Label3D.visible = true
	if currentCard:
		currentCard.material_overlay = savedOutline
		changePos(goalPosition + Vector3(0, 0.02, 0.011))
		hovering = true

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		if(!selected):
			if(get_parent().get_parent().selectCardFunc(values, self)):
				selected = true
				changePos(goalPosition + Vector3(0, 0.05, 0.01))
				$Label3D.text = "Unselect card"
		else:
			selected = false
			changePos(goalPosition - Vector3(0, 0.05, 0.01))
			$Label3D.text = "Select card"
			get_parent().get_parent().unselectCardFunc(values, self)

func disableCards():
	$CollisionShape3D.disabled = true

func activateCards():
	$CollisionShape3D.disabled = false

func cardUsed(textVariables, pulseIntensity):
	if(textVariables != null):
		popUpText(textVariables)
	get_parent().get_parent().screenShake.shake()
	pulse(pulseIntensity)
	
	glow()

var backToNormalSpeed = 0.1

func popUpText(textVariables):
	var newPopUpLabel: Label3D = $Label3D.duplicate()
	add_child(newPopUpLabel)
	newPopUpLabel.modulate = textVariables[1]
	newPopUpLabel.text = textVariables[0]
	newPopUpLabel.scale = Vector3.ZERO
	newPopUpLabel.visible = true
	var posTween = create_tween()
	var endPos = Vector3(randf_range(-0.1, 0.1), randf_range(0.05, 0.15), 0)
	var textLifeTime = randf_range(1, 2)
	var scaleTween = create_tween()
	scaleTween.tween_property(newPopUpLabel, "scale", Vector3(0.1,0.1,0.1), 0.1)
	scaleTween.play()
	posTween.tween_property(newPopUpLabel, "position", endPos, textLifeTime)
	posTween.play()
	await get_tree().create_timer(textLifeTime - 0.1).timeout
	scaleTween = create_tween()
	scaleTween.tween_property(newPopUpLabel, "scale", Vector3.ZERO, 0.1)
	scaleTween.play()
	await scaleTween.finished
	newPopUpLabel.queue_free()

var returningToPos = false

func pulse(intensity):
	rotation_degrees += Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5)) * intensity
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

func glow():
	for i in randi_range(2, 4):
		var newParticles: CPUParticles3D = $activatedParticles.duplicate()
		add_child(newParticles)
		newParticles.material_override.albedo_color = Color(randf(), randf(), randf())
		newParticles.emitting = true

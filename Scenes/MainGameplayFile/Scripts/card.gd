extends StaticBody3D

signal showCard
signal destroyCard
signal cheat

var hidden = false
var showing = false
var distracted = true

func setDistracted(val: bool):
	distracted = val
	if showing and !val and hidden:
		showing=false
		while(self.rotation_degrees != Vector3(-45-180,0, 0) and !showing):
			rotation_degrees = lerp(rotation_degrees, Vector3(-45-180,0, 0), 0.25)
			await get_tree().create_timer(0.02).timeout

func setCard(card: MeshInstance3D, hid: bool):
	add_child(card)
	card.position = Vector3.ZERO
	
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

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and distracted:
		if event.pressed:
			
			if hidden:
				print(hidden)
				showing = true
				while(showing):
					rotation_degrees = lerp(rotation_degrees, Vector3(-45,0,0), 0.25)
					await get_tree().create_timer(0.02).timeout
			else:
				destroyCard.emit()
		else:
			if showing and hidden: 
				showing = false
				while(self.rotation_degrees != Vector3(-45-180,0, 0) and !showing):
					rotation_degrees = lerp(rotation_degrees, Vector3(-45-180,0, 0), 0.25)
					await get_tree().create_timer(0.02).timeout

func _on_mouse_exited() -> void:
	if showing: 
		showing = false
		while(self.rotation_degrees != Vector3(-45-180,0, 0) and !showing):
			rotation_degrees = lerp(rotation_degrees, Vector3(-45-180,0, 0), 0.25)
			await get_tree().create_timer(0.02).timeout

func _on_mouse_entered() -> void:
	pass # Replace with function body.

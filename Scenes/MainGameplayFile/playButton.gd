extends StaticBody3D

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var check = get_tree().current_scene.startGame || null
			if check != null:
				get_tree().current_scene.startGame.emit()

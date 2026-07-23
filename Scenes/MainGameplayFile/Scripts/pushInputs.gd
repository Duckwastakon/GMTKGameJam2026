extends StaticBody3D

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var mouse3d = $MeshInstance3D.global_transform.affine_inverse() * event_position
			var calculated2dPos = Vector2(mouse3d.x, mouse3d.z)
			
			var planeSize = $MeshInstance3D.mesh.size
			calculated2dPos += planeSize/2
			calculated2dPos /= planeSize
			
			var mouse2d = calculated2dPos * Vector2($SubViewport.size)
			
			event.position = mouse2d
			
			$SubViewport.push_input(event)
			print(mouse2d)

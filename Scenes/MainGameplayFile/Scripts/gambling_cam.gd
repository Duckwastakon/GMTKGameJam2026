extends Camera3D

const maxDegrees = 15

func _process(delta: float) -> void:
	var windowSize = get_window().size
	var mousePos = get_viewport().get_mouse_position()
	
	var rotationY = -maxDegrees * ((mousePos.x - windowSize.x / 2) / (windowSize.x / 2))
	var rotationX = -maxDegrees * ((mousePos.y - windowSize.y / 2) / (windowSize.y / 2))
	rotation = Vector3(deg_to_rad(-30) + deg_to_rad(rotationX), deg_to_rad(rotationY), 0)

extends Node3D

func shake(intensity = 0.025):
	if(rotation == Vector3.ZERO):
		for i in 4:
			rotation += Vector3(randf_range(-intensity, intensity), randf_range(-intensity, intensity), randf_range(-intensity, intensity))
			await get_tree().create_timer(0.02).timeout
		while(rotation != Vector3.ZERO):
			rotation = lerp(rotation, Vector3.ZERO, 0.1)
			await get_tree().create_timer(0.0025).timeout
	else:
		for i in 4:
			rotation += Vector3(randf_range(-intensity, intensity), randf_range(-intensity, intensity), randf_range(-intensity, intensity))
			await get_tree().create_timer(0.02).timeout

extends TextureRect



func _on_close_mouse_entered() -> void:
	$closeCredits.modulate = Color(0.606, 0.0, 0.0, 1.0)

func _on_close_mouse_exited() -> void:
	$closeCredits.modulate = Color(1.0, 0.4, 0.329, 1.0)

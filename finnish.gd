extends Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$sound/Finish.play()

func _on_leave_pressed() -> void:
	get_tree().quit()

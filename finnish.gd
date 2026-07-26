extends Node3D

func _ready() -> void:
	$sound/Finish.play()

func _on_leave_pressed() -> void:
	get_tree().quit()

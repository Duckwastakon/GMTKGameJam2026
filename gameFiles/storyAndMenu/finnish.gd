extends Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_leave_pressed() -> void:
	AudioSystem.playSFX("res://sfx/click.ogg")
	TransitionController.ChangeScene("res://storyAndMenu/main_menue.tscn")

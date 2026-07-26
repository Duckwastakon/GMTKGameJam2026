extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for s: AudioStreamPlayer in get_children():
		s.volume_db = (-4 + (8 * (Global.volume / 100))) * 3

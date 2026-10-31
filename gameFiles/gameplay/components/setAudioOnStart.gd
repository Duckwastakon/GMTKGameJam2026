extends AudioStreamPlayer2D

@export var base = 0
func _ready() -> void:
	volume_db = base + (8 * (Global.volume - 50) / 50)

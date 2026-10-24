extends Node2D

@onready var audioPrefab = $AudioStreamPlayer2D

func _ready() -> void:
	audioPrefab.volume_db = 0 + (8 * (Global.volume - 50) / 50)

func playSFX(sfx, pitch = 1, base = 0):
	var newAudio: AudioStreamPlayer2D = audioPrefab.duplicate()
	add_child(newAudio)
	newAudio.pitch_scale = pitch
	newAudio.volume_db = base + (8 * (Global.volume - 50) / 50)
	newAudio.stream = load(sfx)
	newAudio.play()
	await newAudio.finished
	newAudio.queue_free()

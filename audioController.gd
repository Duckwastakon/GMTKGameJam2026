extends Node


func playAudio(audio: AudioStream, global_pos):
	var newAudio = AudioStreamPlayer3D.new()
	newAudio.stream = audio
	newAudio.volume_db = -5 + Global.volume / 10
	add_child(newAudio)
	newAudio.global_position = global_pos
	newAudio.play()
	

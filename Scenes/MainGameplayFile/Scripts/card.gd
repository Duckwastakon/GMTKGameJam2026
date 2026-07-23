extends Node3D

signal showCard
var hidden = false

func setCard(card: MeshInstance3D, hidden: bool):
	add_child(card)
	card.position = Vector3.ZERO
	
	if hidden:
		hidden = true
		card.rotation_degrees = Vector3(-45-180,0, 0)
		await showCard
		var newTween = create_tween()
		newTween.tween_property(card, "rotation_degrees", Vector3(-45,0,0), 0.5)
		newTween.play()
	else:
		card.rotation_degrees = Vector3(90,0,0)
		var newTween = create_tween()
		newTween.tween_property(card, "rotation_degrees", Vector3(-45,0,0), 0.5)
		newTween.play()

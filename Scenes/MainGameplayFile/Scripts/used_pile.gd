extends Node3D


func _on_child_entered_tree(card: Node) -> void:
	var newTween = create_tween()
	newTween.tween_property(card, "position", Vector3.ZERO, 0.1)
	newTween.play()
	var newTween2 = create_tween()
	newTween2.tween_property(card, "rotation_degrees", Vector3(90, 0, 0), 0.1)
	newTween2.play()
	await newTween.finished
	
	card.queue_free()

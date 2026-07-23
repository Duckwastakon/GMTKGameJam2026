extends MeshInstance3D

signal showCard

func setText(str: String, hidden: bool):
	if hidden:
		rotation_degrees = Vector3(0,0, 180)
		await showCard
		$Label3D.text = str
		var newTween = create_tween()
		newTween.tween_property(self, "rotation_degrees", Vector3(0,0,0), 0.5)
		newTween.play()
	else:
		$Label3D.text = str

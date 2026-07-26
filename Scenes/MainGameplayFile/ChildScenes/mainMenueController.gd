extends CanvasLayer

func _ready() -> void:
	for i: TextureButton in $Control/Node.get_children():
		i.connect("button_down", swing.bind(i))

func swing(btn: TextureButton):
	var startPos = btn.position
	var newTween = create_tween()
	newTween.set_ease(Tween.EASE_IN)
	newTween.tween_property(btn, "position", startPos + Vector2(0, 5), 0.05)
	newTween.play()
	
	await btn.button_up
	btn.disabled = true
	newTween.stop()
	newTween = create_tween()
	newTween.tween_property(btn, "position", startPos, 0.05)
	newTween.play()
	await newTween.finished
	btn.disabled = false

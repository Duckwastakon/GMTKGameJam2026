extends CanvasLayer

func _ready() -> void:
	$"../sound/Menu".play()
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

func _on_play_button_up() -> void:
	Global.round = 0
	Global.cash = 500
	TransitionController.ChangeScene("res://Scenes/MainGameplayFile/desert.tscn")

func _on_close_button_up() -> void:
	var newTween = create_tween()
	newTween.tween_property($Control/settings/background, "position", Vector2(344, 700), 0.2)
	newTween.play()
	
	await newTween.finished
	
	for b in $Control/Node.get_children():
		b.disabled = false

func _on_settings_button_up() -> void:
	for b in $Control/Node.get_children():
		b.disabled = true
	
	var newTween = create_tween()
	newTween.tween_property($Control/settings/background, "position", Vector2(344, 152), 0.2)
	newTween.play()

func _on_close_credits_button_up() -> void:
	var newTween = create_tween()
	newTween.tween_property($Control/Credits, "position", Vector2(344, 700), 0.2)
	newTween.play()
	
	await newTween.finished
	
	for b in $Control/Node.get_children():
		b.disabled = false


func _on_credits_button_up() -> void:
	for b in $Control/Node.get_children():
		b.disabled = true
	
	var newTween = create_tween()
	newTween.tween_property($Control/Credits, "position", Vector2(344, 140), 0.2)
	newTween.play()

extends CanvasLayer




func _on_play_hand_button_up() -> void:
	get_parent().playHand.emit()

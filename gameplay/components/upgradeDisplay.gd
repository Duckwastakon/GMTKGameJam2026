extends Control

var hovering = false
var goalPosition = Vector2.ZERO

var moving = false

func setPos(newPos):
	goalPosition = newPos
	
	if(hovering):
		goalPosition -= Vector2(0, 8)
	
	if !moving:
		moving = true
		while(self.position != goalPosition):
			position = lerp(position, goalPosition, 0.25)
			await get_tree().create_timer(0.01).timeout
		moving = false

func changePos(newPos):
	goalPosition = newPos
	
	if !moving:
		moving = true
		while(self.position != goalPosition):
			position = lerp(position, goalPosition, 0.25)
			await get_tree().create_timer(0.01).timeout
		moving = false

func _on_mouse_entered() -> void:
	changePos(goalPosition - Vector2(0, 8))
	z_index = 1
	$infoText.visible = true

func _on_mouse_exited() -> void:
	changePos(goalPosition + Vector2(0, 8))
	z_index = 0
	$infoText.visible = false

func cardUsed(txt, col):
	bopCard(self, 2)

func bopCard(editedLabel, intensity = 1):
	if(editedLabel.scale == Vector2.ONE and editedLabel.rotation_degrees == 0):
		editedLabel.scale *= randf_range(1.05, 1.2) * intensity
		editedLabel.rotation_degrees += randi_range(-3, 3) * intensity
		
		while(editedLabel.scale != Vector2.ONE or editedLabel.rotation_degrees != 0):
			editedLabel.scale = lerp(editedLabel.scale, Vector2.ONE, 0.1)
			editedLabel.rotation_degrees = lerp(editedLabel.rotation_degrees, 0.0, 0.1)
			await get_tree().create_timer(0.05).timeout
	else:
		editedLabel.scale *= randf_range(1.05, 1.2) * intensity
		editedLabel.rotation_degrees += randi_range(-3, 3) * intensity

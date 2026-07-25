extends Sprite3D

var yMovement = 0.05
var speed = 0.5

func _ready() -> void:
	while(true):
		var tween1 = create_tween()
		tween1.tween_property(self, "position", Vector3(0, yMovement, 0), speed)
		tween1.play()
		await tween1.finished
		var tween2 = create_tween()
		tween2.tween_property(self, "position", Vector3(0, -yMovement, 0), speed)
		tween2.play()
		await tween2.finished

extends StaticBody3D

@export var cashPercent: int

func _ready() -> void:
	connect("input_event", emitSignal)

func emitSignal(cam, event, event_pos, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			print("emitting")
			get_tree().current_scene.addBet.emit(cashPercent)

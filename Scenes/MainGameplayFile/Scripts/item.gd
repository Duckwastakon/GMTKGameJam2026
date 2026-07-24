extends StaticBody3D

var item: String = "upgrade"
var active = false
var uses = 3

var itemName: String

func _ready() -> void:
	if get_tree().current_scene.name == "gamblingScene":
		get_tree().current_scene.connect("useItem", destroy_item)

func setItem(gottenName: String, newUses: int, abilityName: String):
	item = abilityName
	uses = newUses


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if get_tree().current_scene.name == "gamblingScene":
				if item != "":
					active = true
					get_tree().current_scene.specialPower(item)

func destroy_item() -> void:
	if active:
		uses -= 1
		if uses > 0:
			active = false
			return
		item = ""
		for c in get_children():
			if c is MeshInstance3D:
				c.queue_free()
			if c is CollisionShape3D:
				c.disabled = true


func _on_mouse_entered() -> void:
	$Label3D.visible = true


func _on_mouse_exited() -> void:
	$Label3D.visible = false

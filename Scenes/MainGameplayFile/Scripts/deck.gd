extends StaticBody3D

var distracted = false
var showing = false

var topCard: MeshInstance3D

@export var cardController: Node3D

func _ready() -> void:
	if cardController:
		cardController.connect("distracted", setDistracted)
		cardController.connect("cardDrawn", discardTopCard)

func setDistracted(val: bool):
	distracted = val
	if showing:
		showing = val
	
	if val:
		$Label3D.text = "peek next card"
	else:
		$Label3D.text = ""

func discardTopCard():
	if topCard:
		topCard.queue_free()
		topCard = null
		print("destroyed")

func createTopCard():
	var nextCard: MeshInstance3D = get_tree().current_scene.deck[0]
	var newCard = nextCard.duplicate()
	add_child(newCard)
	newCard.rotation_degrees = Vector3(90, 0, 0)
	newCard.position = Vector3(0, 0.015, 0)
	
	topCard = newCard


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and distracted:
		if event.pressed:
			showing = true
			if topCard == null:
				await createTopCard()
			while(showing and topCard != null and distracted):
				topCard.rotation_degrees = lerp(topCard.rotation_degrees, Vector3(-30,0,0), 0.25)
				await get_tree().create_timer(0.02).timeout
			if(!distracted):
				showing = false
				while(self.rotation_degrees != Vector3(90,0, 0) and !showing and topCard != null):
					topCard.rotation_degrees = lerp(topCard.rotation_degrees, Vector3(90,0, 0), 0.25)
					await get_tree().create_timer(0.02).timeout
		else:
			if showing and topCard != null: 
				showing = false
				while(self.rotation_degrees != Vector3(90,0, 0) and !showing and topCard != null):
					topCard.rotation_degrees = lerp(topCard.rotation_degrees, Vector3(90,0, 0), 0.25)
					await get_tree().create_timer(0.02).timeout

func _on_mouse_entered() -> void:
	$Label3D.visible = true

func _on_mouse_exited() -> void:
	$Label3D.visible = false
	if showing and topCard != null: 
		showing = false
		while(self.rotation_degrees != Vector3(90,0, 0) and !showing and topCard != null):
			topCard.rotation_degrees = lerp(topCard.rotation_degrees, Vector3(90,0, 0), 0.25)
			await get_tree().create_timer(0.02).timeout

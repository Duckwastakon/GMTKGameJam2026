extends CanvasLayer


@export var item: MeshInstance3D
@export var Player: CharacterBody3D

func setItem(newItem):
	item = newItem

func _process(delta: float) -> void:
	if item:
		self.visible = item.visible
	else:
		self.visible = false
		return
	
	var itemPos: Vector3 = item.global_position
	var playerPos = Player.global_position
	print(Vector2(itemPos.x, itemPos.z).angle_to(Vector2(itemPos.x, itemPos.z)))
	$TextureRect.rotation_degrees = rad_to_deg(Vector2(itemPos.x, itemPos.z).angle_to(Vector2(itemPos.x, 
	itemPos.z)))
	print(playerPos.direction_to(itemPos))
	print(Player.rotation)

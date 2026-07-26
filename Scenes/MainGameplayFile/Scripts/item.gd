extends StaticBody3D

var item: String = "upgrade"
var active = false
var uses = 3

var itemName: String = "Scissors"

var savedMaterial: StandardMaterial3D
var savedOutline: ShaderMaterial

var item_Abilities_Models = {
	"Scissors" = {
		"power": "destroy",
		"meshLoad": null,
		"itemScale": 0.1
	},
	"Gun" = {
		
	},
	"Magic wand" = {
		"power": "upgrade",
		"meshLoad": load("res://Models_Art/models/Wand.mesh"),
		"itemScale": Vector3(0.02, 0.1, 0.02),
	}
}

var hoverShader = load("res://Scenes/MainGameplayFile/ChildScenes/outlineShader.gdshader")


func _ready() -> void:
	if get_tree().current_scene.name == "gamblingScene":
		get_tree().current_scene.connect("useItem", destroy_item)

func setItem(gottenName: String):
	visible = true
	var itemStats = item_Abilities_Models[gottenName]
	item = itemStats.power
	uses = 3
	itemName = gottenName
	
	$MeshInstance3D.mesh = itemStats.meshLoad
	$MeshInstance3D.scale = itemStats.itemScale
	$Label3D.text = "use " + gottenName
	
	var newShaderMaterial = ShaderMaterial.new()
	newShaderMaterial.shader = hoverShader
	newShaderMaterial.set_shader_parameter("outline_color", Color.WHITE)
	newShaderMaterial.set_shader_parameter("outline_width", 1)
	var newMaterial = StandardMaterial3D.new()
	newMaterial.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	newMaterial.albedo_color.a = 0.2
	newShaderMaterial.next_pass = newMaterial
	
	savedMaterial = newMaterial
	savedOutline = newShaderMaterial
	
	#$MeshInstance3D.mesh = newShaderMaterial

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if get_tree().current_scene.name == "gamblingScene":
				if active:
					active = false
					get_tree().current_scene.specialPower("")
					return
				
				for c in get_parent().get_children():
					c.active = false
				if item != "":
					active = true
					get_tree().current_scene.specialPower(item)
					get_tree().current_scene.editInteractMessage.emit(itemName)
					
					var originalPos = position
					$Label3D.text = "cancel " + itemName
					while(active):
						position = lerp(position, originalPos + Vector3(0, 0.1, 0), 0.25)
						await get_tree().create_timer(0.02).timeout
					
					get_tree().current_scene.editInteractMessage.emit("")
					var newTween = create_tween()
					newTween.tween_property(self, "position", originalPos, 0.2)
					newTween.play()
					$Label3D.text = "use " + itemName

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
	
	$MeshInstance3D.material_overlay = savedOutline


func _on_mouse_exited() -> void:
	$Label3D.visible = false
	
	$MeshInstance3D.material_overlay = null

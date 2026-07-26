extends StaticBody3D

var savedMaterial
var savedOutline

var hoverShader = load("res://Scenes/MainGameplayFile/ChildScenes/outlineShader.gdshader")

func _ready() -> void:
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


func _on_mouse_entered() -> void:
	if get_tree().current_scene.canDraw == false: return
	for c in get_children():
		if c is MeshInstance3D:
			c.material_overlay.next_pass = savedMaterial


func _on_mouse_exited() -> void:
	for c in get_children():
		if c is MeshInstance3D:
			c.material_overlay.next_pass = null

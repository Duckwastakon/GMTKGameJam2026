extends MeshInstance3D


func _ready() -> void:
	var neededSignal = get_tree().current_scene.betChanged || null
	
	if neededSignal != null:
		get_tree().current_scene.connect("betChanged", updateCounter)

func updateCounter(amt: int, show: bool = false, message: String = ""):
	if message != "":
		$Label3D.text = message
		await get_tree().create_timer(2).timeout
	$Label3D.text = "$" + str(amt)

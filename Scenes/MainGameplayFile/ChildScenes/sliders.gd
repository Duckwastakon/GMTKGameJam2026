extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$screenShake/SS.value = Global.screenShake
	$volume/V.value = Global.volume
	$sensitivity/S.value = Global.sensitivity

func _on_s_value_changed(value: float) -> void:
	Global.sensitivity = int(value)
	$sensitivity/S.value = Global.sensitivity

func _on_v_value_changed(value: float) -> void:
	Global.volume = int(value)
	$volume/V.value = Global.volume

func _on_ss_value_changed(value: float) -> void:
	Global.screenShake = int(value)
	$screenShake/SS.value = Global.screenShake

func _on_close_mouse_entered() -> void:
	$close.modulate = Color(0.606, 0.0, 0.0, 1.0)

func _on_close_mouse_exited() -> void:
	$close.modulate = Color(1.0, 0.4, 0.329, 1.0)

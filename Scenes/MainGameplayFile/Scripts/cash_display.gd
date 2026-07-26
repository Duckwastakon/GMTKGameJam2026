extends CanvasLayer


var lastAmount: int

@onready var clonable = $clonableChange

const colorValues = {
	false: Color(1,0,0,1),
	true: Color(0,1,0,1)
}

func _ready() -> void:
	$Label.text = "$" + str(Global.cash)
	lastAmount = Global.cash
	
	Global.cashUpdated.connect(updateText)

func updateText(amt: int):
	$Label.text = "$" + str(Global.cash)
	var clr = colorValues[(amt>0)]
	
	var newText = clonable.duplicate()
	add_child(newText)
	newText.global_position = $Label.global_position
	newText.text = str(amt)
	newText.visible = true
	newText.modulate = clr
	var newTween = create_tween()
	var transparencyTween = create_tween()
	transparencyTween.tween_property(newText, "modulate", clr * Color(1,1,0,0), 1.5)
	newTween.tween_property(newText, "global_position", newText.global_position + Vector2(randi_range(-20, 20), 
	randi_range(-100, -50)), 0.75)
	newTween.play()
	transparencyTween.play()
	
	await newTween.finished
	
	newTween.kill()
	newText.queue_free()

func setEVisible(val:bool):
	$pressEIndicator.visible = val

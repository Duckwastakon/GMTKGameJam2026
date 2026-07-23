extends Control

@onready var betButtons = $betIncreaseButtons.get_children()

func increaseBet(amt: int):
	print("clicked")
	get_tree().current_scene.addBet.emit(amt)

func _ready() -> void:
	var neededSignal = get_tree().current_scene.betChanged || null
	
	if neededSignal != null:
		get_tree().current_scene.connect("betChanged", updateCounter)
	
	var check = get_tree().current_scene.addBet || null
	if check != null:
		for btn: Button in betButtons:
			print("connected")
			btn.connect("button_down", increaseBet.bind(int(btn.get_child(1).text)))

func _on_play_button_button_down() -> void:
	var check = get_tree().current_scene.startGame || null
	if check != null:
		get_tree().current_scene.startGame.emit()

func updateCounter(amt: int, show: bool = false, message: String = ""):
	if message != "":
		$Label.text = message
		await get_tree().create_timer(2).timeout
	$Label.text = "$" + str(amt)

extends Control

@onready var betButtons = $betIncreaseButtons.get_children()
var currentBet = 0

func increaseBet(amt: int):
	print("clicked")
	get_tree().current_scene.addBet.emit(amt)

func _ready() -> void:
	var neededSignal = get_tree().current_scene.betChanged || null
	
	if neededSignal != null:
		get_tree().current_scene.connect("betChanged", updateCounter)
		get_tree().current_scene.connect("reachEndSignal", disableButtons)
	
	var check = get_tree().current_scene.addBet || null
	if check != null:
		for btn: TextureButton in betButtons:
			btn.connect("button_down", increaseBet.bind(int(btn.get_child(0).text)))

func _on_play_button_button_down() -> void:
	var check = get_tree().current_scene.startGame || null
	if check != null:
		if get_tree().current_scene.inTut == true or currentBet == 0: return
		get_tree().current_scene.startGame.emit()
		$playButton.self_modulate = Color(0.0, 0.835, 0.835, 1.0)
		$playButton/Label.text = "Game in progress"

func updateCounter(amt: int, show: bool = false, message: String = ""):
	if amt > 0:
		$playButton.self_modulate = Color(0.426, 0.889, 0.419, 1.0)
	else:
		$playButton.self_modulate = Color(0.384, 0.384, 0.384, 1.0)
	
	$playButton/Label.text = "Play"
	
	if message != "":
		$Label.text = message
		await get_tree().create_timer(2).timeout
	$Label.text = "$" + str(amt)
	currentBet = amt

func disableButtons():
	$playButton.disabled = true
	for btn in $betIncreaseButtons.get_children():
		btn.disabled = true

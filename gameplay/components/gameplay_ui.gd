extends CanvasLayer

var cash = 0
func _ready() -> void:
	CardCalculator.updateCash.connect(UpdateCashText)
	CardCalculator.selectCard.connect(updateSelectedText)
	get_parent().endHand.connect(endHand)
	get_parent().levelEnded.connect(activateShopControlls)
	CardCalculator.updateAmount.connect(updateAmount)
	CardCalculator.updateMultiplier.connect(updateMultiplier)
	CardCalculator.buyCard.connect(addShopCard)
	CardCalculator.updateTokens.connect(updateTokens)
	CardCalculator.setRerollPrice.connect(updateRerollPrice)
	CardCalculator.setNeededScore.connect(updateNeededScore)
	CardCalculator.setLevel.connect(updateLevel)

func _on_play_hand_button_up() -> void:
	get_parent().playHand.emit()
	
	$handControlls.visible = false
	$earningDisplay/amountText.text = "0"
	lastAmount = 0
	lastMultiplier = 1
	$earningDisplay/multiplierText.text = "1"
	$earningDisplay.visible = true

func updateSelectedText(amount):
	if(amount > 0):
		$handControlls/selectedCardAmount.text = str(amount) + "/" + str(get_parent().maxEquipCards) + " cards"
		$handControlls/playHand.self_modulate = Color(0.533, 0.937, 0.635)
		$handControlls/playHand.disabled = false
	else:
		$handControlls/selectedCardAmount.text = "select some cards"
		$handControlls/playHand.self_modulate = Color(0.675, 0.663, 0.624)
		$handControlls/playHand.disabled = true
	
	bopText($handControlls/selectedCardAmount, 1.2)

func endHand():
	$handControlls/selectedCardAmount.text = "Select some cards"
	$handControlls/playHand.self_modulate = Color(0.675, 0.663, 0.624)
	$handControlls/playHand.disabled = true
	$handControlls.visible = true
	$earningDisplay.visible = false
	$handControlls/handLeftAmount.text = "Hands left: " + str(get_parent().handsLeft)
	bopText($handControlls/handLeftAmount)

func bopText(editedLabel, intensity = 1):
	if(editedLabel.scale == Vector2.ONE and editedLabel.rotation_degrees == 0):
		editedLabel.scale *= randf_range(1.05, 1.2) * intensity
		editedLabel.rotation_degrees += randi_range(-3, 3) * intensity
		
		while(editedLabel.scale != Vector2.ONE or editedLabel.rotation_degrees != 0):
			editedLabel.scale = lerp(editedLabel.scale, Vector2.ONE, 0.1)
			editedLabel.rotation_degrees = lerp(editedLabel.rotation_degrees, 0.0, 0.1)
			await get_tree().create_timer(0.05).timeout
	else:
		editedLabel.scale *= randf_range(1.05, 1.2) * intensity
		editedLabel.rotation_degrees += randi_range(-3, 3) * intensity

func textIndicator(obj, txt, col, outlineCol):
	var newLabel = Label.new()
	newLabel.text = txt
	newLabel.size = obj.size
	newLabel.pivot_offset = newLabel.size/2
	newLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	newLabel.horizontal_alignment = VERTICAL_ALIGNMENT_CENTER
	newLabel.scale = obj.scale
	newLabel.global_position = obj.global_position
	newLabel.label_settings = LabelSettings.new()
	newLabel.label_settings.font_size = 12
	newLabel.label_settings.outline_size = 4
	newLabel.label_settings.font_color = col
	newLabel.label_settings.outline_color = outlineCol
	newLabel.rotation_degrees = randi_range(-15, 15)
	add_child(newLabel)
	var newPosDif = Vector2(randi_range(-64, 64), randi_range(-16, -32))
	var posTween = create_tween()
	posTween.tween_property(newLabel, "global_position", newLabel.global_position + newPosDif, 1)
	await posTween.finished
	var scaleTween = create_tween()
	scaleTween.tween_property(newLabel, "scale", Vector2.ZERO, 0.1)
	scaleTween.play()
	await scaleTween.finished
	newLabel.queue_free()

var lastAmount = 0
func updateAmount(amount):
	$earningDisplay/amountText.text = str(amount)
	
	bopText($earningDisplay/amountText)
	var dif = amount - lastAmount
	if (dif > 0):
		textIndicator($earningDisplay/amountText, "+" + str(dif), Color(0.995, 1.0, 0.693, 1.0), Color(0.993, 0.798, 0.568, 1.0))
	lastAmount = amount

var lastMultiplier = 0
func updateMultiplier(amount):
	$earningDisplay/multiplierText.text = str(amount)
	
	bopText($earningDisplay/multiplierText)
	
	var dif = amount - lastMultiplier
	if (dif > 0):
		textIndicator($earningDisplay/multiplierText, "+" + str(dif), Color(0.849, 0.815, 1.0, 1.0), Color(0.0, 0.949, 0.99, 1.0))
	lastMultiplier = amount

func UpdateCashText(amount):
	$levelInfo/currentCash.text = "score: " + str(amount)
	var difference = amount - cash
	cash = amount
	
	if(difference > 0):
		var newLabel: Label = $levelInfo/currentCash.duplicate()
		add_child(newLabel)
		newLabel.text = str(difference) + "$"
		newLabel.global_position = $levelInfo/currentCash.global_position
		newLabel.modulate = Color(0.628, 1.0, 0.598, 1.0)
		var scaleTween = newLabel.create_tween()
		scaleTween.tween_property(newLabel, "modulate", Color(1,1,1,0), 1)
		var posTween = newLabel.create_tween()
		posTween.tween_property(newLabel, "global_position", newLabel.global_position - Vector2(0, 32), 1)
		posTween.play()
		scaleTween.play()
		await posTween.finished
		newLabel.queue_free()

var boughtUpgrades = []

func activateShopControlls():
	$handControlls.visible = false
	$earningDisplay.visible = false
	$ShopControlls.visible = true
	
	$levelInfo/neededCash.text = "level passed"

@onready var upgradePrefab: Control = $upgrade
@onready var upgradeContainer = $cardInfo/cardContainer

func addShopCard(id):
	var newCard = upgradePrefab.duplicate()
	var power = Global.powerId[id]
	newCard.visible = true
	newCard.get_child(0).texture = load(power["img"])
	newCard.get_child(1).text = power["txt"]
	upgradeContainer.add_child(newCard)
	newCard.position = Vector2.ZERO
	
	sortBoughtUpgrades()
	CardCalculator.addPowerUp(id, newCard)

func sortBoughtUpgrades():
	var cardAmount = upgradeContainer.get_child_count()
	var containerSize = upgradeContainer.size.x - 76
	var sizePerCard = containerSize/cardAmount
	
	for i in cardAmount:
		var card = upgradeContainer.get_child(i)
		var newPos = Vector2(8+(sizePerCard/2)+sizePerCard*(i),8)
		card.setPos(newPos)

func _on_start_round_button_up() -> void:
	get_parent().startLevel()
	
	$handControlls.visible = true
	$earningDisplay.visible = false
	$ShopControlls.visible = false
	$handControlls/selectedCardAmount.text = "Select some cards"
	$handControlls/handLeftAmount.text = "Hands left: 3"
	$handControlls/playHand.self_modulate = Color(0.675, 0.663, 0.624)
	$handControlls/playHand.disabled = true

func _on_reroll_hand_button_up() -> void:
	get_parent().rerollShop()
	$ShopControlls/rerollHand.disabled = true
	await get_tree().create_timer(1).timeout
	$ShopControlls/rerollHand.disabled = false

func updateTokens(amount):
	$levelInfo/shopCredits.text = str(amount) + "$"

func updateRerollPrice(amount):
	$ShopControlls/price.text = "Reroll for: " + str(amount) + "$"

func updateNeededScore(amount):
	$levelInfo/neededCash.text = "Needed score: " + str(amount)

func updateLevel(amount):
	$levelInfo/levelDisplay.text = "Round: " + str(amount)

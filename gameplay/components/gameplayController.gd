extends Node3D

@export var Bob: Node3D

@export var cardContainer: Node3D
@export var deckNode: Node3D
@export var gainedCash: Label3D

var cardsOnField = []
var selectedCards = []
var deck = []

var maxEquipCards = 3
var cash = 0
var handsLeft = 1
var neededAmount = 0
var shopTokens = 0
var round = 0

signal levelStarted
signal levelEnded

signal playHand
signal endHand

signal startTutorial
signal endTutorial

const cardScene = preload("res://gameplay/components/card.tscn")

@onready var allCards = $allPossibleCards.get_children()

var drawDelay = 0.1

var cardTypes = {
	"Two": 2,
	"Three": 3,
	"Four": 4,
	"Five": 5,
	"Six": 6,
	"Seven": 7,
	"Eight": 8,
	"Nine": 9,
	"Ten": 10,
	"Jack": 11,
	"Queen": 12,
	"King": 13,
	"Ace": 14,
}

var symbolTypes = {
	"Hearts": 0,
	"Diamonds": 1,
	"Clubs": 2,
	"Spades": 3
}

func sortCards(newCard, val):
	var cardAdded = false
	var newList = []
	for i in cardsOnField:
		var cardsVals = i.values
		if cardTypes[val[1]] <= cardTypes[cardsVals[1]] and !cardAdded:
			if cardTypes[val[1]] == cardTypes[cardsVals[1]]:
				if symbolTypes[val[0]] < symbolTypes[cardsVals[0]]:
					newList.append(newCard)
					cardAdded = true
			else:
				newList.append(newCard)
				cardAdded = true
		newList.append(i)
	
	if (!cardAdded):
		newList.append(newCard)
	
	cardsOnField = newList
	var sizePerCard = 0.1
	
	var cardAmount = cardsOnField.size()
	
	for i in cardsOnField.size():
		var card = cardsOnField[i]
		card.setPos(Vector3(-(sizePerCard/2)*(cardAmount-1) + (sizePerCard) * i, 0, 0.001 * i))

func generateFullField():
	while(cardsOnField.size() < 8):
		spawnCard()
		await get_tree().create_timer(drawDelay).timeout

func spawnCard():
	AudioSystem.playSFX("cardSwoosh")
	if(deck.size()<1):
		fillDeck()
	
	var nextCard = deck.pop_back()
	
	var newCard = cardScene.instantiate()
	cardContainer.add_child(newCard)
	newCard.global_position = deckNode.global_position
	var cardName: String = nextCard.name
	var cardValues = cardName.split("_")
	
	newCard.setCard(nextCard, cardValues)
	sortCards(newCard, cardValues)
	playHand.connect(newCard.disableCards)
	endHand.connect(newCard.activateCards)
	return newCard

func fillDeck():
	deck.clear()
	
	for x in 1:
		for card in allCards:
			deck.append(card)
	
	for i in 256:
		var temp
		var rand1 = randi_range(0, deck.size() - 1)
		var rand2 = randi_range(0, deck.size() - 1)
		
		temp = deck[rand1]
		deck[rand1] = deck[rand2]
		deck[rand2] = temp

func startLevel():
	round += 1
	CardCalculator.setLevel.emit(round)
	rerollPrice = 3
	CardCalculator.setRerollPrice.emit(rerollPrice)
	
	if upgradeCards.size() > 0:
		for i in upgradeCards.size():
			var card = upgradeCards.pop_front()
			discardCard(card)
			await get_tree().create_timer(0.1).timeout
	
	generateFullField()
	handsLeft = 3
	cash = 0
	CardCalculator.updateCash.emit(cash)
	
	neededAmount = roundi(50*round*sqrt(round))
	CardCalculator.setNeededScore.emit(neededAmount)
	
	Bob.talk("This round get " + str(neededAmount) + " score", true)
	
	levelStarted.emit()

func endLevel():
	if(cash > neededAmount):
		shopTokens += roundi(ceil(sqrt(round) * 3))
		shopTokens += handsLeft
		CardCalculator.updateTokens.emit(shopTokens)
		var difference = cash - neededAmount
		var i = 1
		while(difference >= pow(10, i)):
			i+=1
			shopTokens+=1
			CardCalculator.updateTokens.emit(shopTokens)
		
		levelEnded.emit()
		openShop()
	else:
		looseGame()

func looseGame():
	TransitionController.ChangeScene("res://gameplay/gameplay.tscn")

func _on_play_hand() -> void:
	var sizePerCard = 0.15
	var cardAmount = selectedCards.size()
	
	for i in selectedCards.size():
		var card = selectedCards[i]
		card.setPos(Vector3(-(sizePerCard/2)*(cardAmount-1) + (sizePerCard) * i, 0.1, 0.001 * i))
		await get_tree().create_timer(0.2).timeout
	
	await get_tree().create_timer(0.25).timeout
	
	var gottenAmount = await CardCalculator.calculateAmount(selectedCards)
	cash += gottenAmount
	handsLeft -= 1
	CardCalculator.updateCash.emit(cash)
	
	GottenAmountText(gottenAmount)
	
	await get_tree().create_timer(1.5).timeout
	
	if handsLeft <= 0 or cash >= neededAmount:
		for card in cardsOnField:
			discardCard(card)
			await get_tree().create_timer(drawDelay).timeout
		cardsOnField = []
		selectedCards = []
		
		endLevel()
	else:
		for card in selectedCards:
			cardsOnField.remove_at(cardsOnField.find(card))
			discardCard(card)
			await get_tree().create_timer(drawDelay).timeout
		selectedCards = []
		
		await generateFullField()
		
		endHand.emit()

func GottenAmountText(gottenAmount):
	var newText = gainedCash.duplicate()
	cardContainer.add_child(newText)
	newText.position = Vector3(0,0,0.1)
	newText.text = str(gottenAmount) + "$"
	
	var endSize = 1
	var i = 1
	while(gottenAmount > pow(10, i)):
		i+=1
	
	endSize += 0.1 * i
	
	var ScaleTween = create_tween()
	ScaleTween.tween_property(newText, "scale", Vector3(endSize,endSize,endSize), 0.1)
	ScaleTween.play()
	
	var PosTween = create_tween()
	PosTween.tween_property(newText, "position", Vector3(0,0.15,0.15), 1.5)
	PosTween.play()
	
	await get_tree().create_timer(1.5).timeout
	
	ScaleTween = create_tween()
	ScaleTween.tween_property(newText, "scale", Vector3.ZERO, 0.1)
	ScaleTween.play()
	
	await ScaleTween.finished
	
	newText.queue_free()

func selectCardFunc(selectedCard, cardModel):
	if selectedCards.size() >= maxEquipCards: return false
	selectedCards.append(cardModel)
	CardCalculator.selectCard.emit(selectedCards.size())
	return true

func unselectCardFunc(unselectedCard, cardModel):
	selectedCards.remove_at(selectedCards.find(cardModel))
	CardCalculator.selectCard.emit(selectedCards.size())

func discardCard(discardedCard):
	var posTween = create_tween()
	posTween.tween_property(discardedCard, "global_position", deckNode.global_position, 0.1)
	var rotationTween = create_tween()
	rotationTween.tween_property(discardedCard, "rotation_degrees", Vector3(90,0,0), 0.1)
	
	rotationTween.play()
	posTween.play()
	await posTween.finished
	
	discardedCard.queue_free()

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	gameStart()

var offeredCards = 3
var upgradeCardPrefab = preload("res://gameplay/components/upgrade_card.tscn")
var upgradeCards = []

var shopOpened = false
func openShop():
	if(!shopOpened):
		shopOpened = true
		Bob.talk("Congrats on beating a round", true)
		await get_tree().create_timer(introWaitTime).timeout
		Bob.talk("Now I have given you some shop credits", true)
		await get_tree().create_timer(introWaitTime).timeout
		Bob.talk("buy some upgrades, you will need them", true)
	else:
		Bob.talk("Good job")
	
	for i in offeredCards:
		AudioSystem.playSFX("cardSwoosh")
		
		var nextCardId = randi_range(0, Global.powerId.size()-1)
		
		var newUpgradeCard = upgradeCardPrefab.instantiate()
		cardContainer.add_child(newUpgradeCard)
		newUpgradeCard.global_position = deckNode.global_position
		
		newUpgradeCard.setCard(nextCardId)
		sortUpgradeCards(newUpgradeCard)
		await get_tree().create_timer(0.1).timeout

func sortUpgradeCards(newCard):
	upgradeCards.append(newCard)
	
	var sizePerCard = 0.15
	var cardAmount = upgradeCards.size()
	
	for i in upgradeCards.size():
		var card = upgradeCards[i]
		card.setPos(Vector3(-(sizePerCard/2)*(cardAmount-1) + (sizePerCard) * i, 0.1, 0.001 * i))

func buyCard(amount, card, id):
	if(shopTokens >= amount):
		shopTokens-=amount
		CardCalculator.updateTokens.emit(shopTokens)
		upgradeCards.remove_at(upgradeCards.find(card))
		CardCalculator.buyCard.emit(id)
		return true
	else:
		return false

var rerollPrice = 3

func rerollShop():
	if shopTokens < rerollPrice: return false
	
	shopTokens-=rerollPrice
	rerollPrice = roundi(rerollPrice * sqrt(rerollPrice))
	CardCalculator.setRerollPrice.emit(rerollPrice)
	
	CardCalculator.updateTokens.emit(shopTokens)
	for i in upgradeCards.size():
		var card = upgradeCards.pop_front()
		discardCard(card)
		await get_tree().create_timer(0.1).timeout
	
	openShop()

var introWaitTime = 1.1

func gameStart():
	Bob.talk("The game is quite simple", true)
	await get_tree().create_timer(introWaitTime).timeout
	Bob.talk("Choose cards and reach the needed score", true)
	await get_tree().create_timer(introWaitTime).timeout
	Bob.talk("Most cards just give their value", true)
	await get_tree().create_timer(introWaitTime).timeout
	Bob.talk("As long as you get enough score you can be on my car", true)
	await get_tree().create_timer(introWaitTime).timeout
	Bob.talk("Otherwise I might have to throw you off", true)
	await get_tree().create_timer(introWaitTime).timeout
	
	startLevel()

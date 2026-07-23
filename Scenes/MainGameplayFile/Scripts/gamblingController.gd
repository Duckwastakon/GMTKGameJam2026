extends Node3D

var playersCards: Array[int]
var opponentsCards: Array[int]

@export var playerCardContainer: Node3D
@export var opponentCardContainer: Node3D
@export var usedPile: Node3D

var deck = []

signal finishGame
signal playerDone

var betAmount = 0

signal addBet
signal betChanged
signal startGame

var canDraw = false
var gameActive = false

const cardScene = preload("res://Scenes/MainGameplayFile/ChildScenes/card.tscn")

func shuffleDeck():
	deck.clear()
	
	for x in 10:
		for y in 4:
			deck.append(x+1)
	
	for i in 99:
		var temp
		var rand1 = randi_range(0, deck.size() - 1)
		var rand2 = randi_range(0, deck.size() - 1)
		
		temp = deck[rand1]
		deck[rand1] = deck[rand2]
		deck[rand2] = temp
	
	print(deck)

func playRound() -> bool:
	var hiddenCard = drawCard(opponentsCards, opponentCardContainer, true)
	await get_tree().create_timer(0.5).timeout
	drawCard(playersCards, playerCardContainer)
	await get_tree().create_timer(0.5).timeout
	drawCard(opponentsCards, opponentCardContainer)
	await get_tree().create_timer(0.5).timeout
	drawCard(playersCards, playerCardContainer)
	
	canDraw = true
	
	await playerDone
	
	canDraw = false
	
	hiddenCard.showCard.emit()
	await get_tree().create_timer(1).timeout
	await opponentTurn()
	
	print("opponentFinished")
	
	var sumPlayer = countSum(playersCards)
	var sumOpponent = countSum(opponentsCards)
	
	if(sumPlayer > sumOpponent):
		if(sumPlayer>21):
			return false
		return true
	if(sumOpponent>21 || sumOpponent == sumPlayer):
		return true
	
	return false

func opponentTurn():
	var sumPlayer = countSum(playersCards)
	var sumOpponent = countSum(opponentsCards)
	print("started")
	if(sumPlayer < 22):
		while(sumPlayer>sumOpponent and sumOpponent < 22):
			drawCard(opponentsCards, opponentCardContainer)
			await get_tree().create_timer(1).timeout
		
			sumPlayer = countSum(playersCards)
			sumOpponent = countSum(opponentsCards)
	print("done")

func countSum(arr):
	var num = 0
	
	for n in arr:
		num+=n
	
	return num

func drawCard(arr: Array[int], cont, hidden = false):
	var newCard = cardScene.instantiate()
	newCard.setText(str(deck[0]), hidden)
	cont.add_child(newCard)
	newCard.global_position = Vector3(0, 1, 0)
	arr.append(deck[0])
	deck.pop_at(0)
	
	return newCard

func discardCards() -> void:
	var cards = []
	cards.append_array(opponentCardContainer.get_children())
	cards.append_array(playerCardContainer.get_children())
	for card in cards:
		card.reparent(usedPile)
		await get_tree().create_timer(0.5).timeout
	
	playersCards.clear()
	opponentsCards.clear()

func _ready() -> void:
	connect("addBet", betAdded)
	shuffleDeck()
	
	while(true):
		while(!gameActive):
			await startGame
			if betAmount > 0:
				gameActive = true
		
		var result = await playRound()
		if(result):
			var wonCash: int
			var playerSum = countSum(playersCards)
			var opponentSum = countSum(opponentsCards)
			if(playerSum==21 and playersCards.size() == 2):
				wonCash = betAmount * 2.5
			elif playerSum == opponentSum:
				wonCash = int(betAmount * 1.5)
			else:
				wonCash = betAmount * 2
			
			betChanged.emit(wonCash, true, "won")
			
			await get_tree().create_timer(3).timeout
			
			Global.addCash(wonCash)
			betChanged.emit(0)
		else:
			betChanged.emit(0, true, "lost")
		
		betAmount = 0
		await discardCards()
		gameActive = false
		print("roundDone")


func _on_cash_timer_timeout() -> void:
	Global.addCash(-10)

func betAdded(amount: int):
	if(gameActive): return
	if(amount<0):
		var calculatedAmt = int(betAmount * amount / 100)
		Global.addCash(-calculatedAmt)
		betAmount += calculatedAmt
	else:
		var calculatedAmt = int(Global.cash * amount / 100)
		Global.addCash(-calculatedAmt)
		betAmount += calculatedAmt
	
	print(betAmount)
	betChanged.emit(betAmount, true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("E") and canDraw:
		await drawCard(playersCards, playerCardContainer)
		if(countSum(playersCards) >= 21):
			playerDone.emit()
	
	if event.is_action_pressed("Q") and canDraw:
		playerDone.emit()


func _on_hit_button_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and canDraw:
		if event.pressed:
			await drawCard(playersCards, playerCardContainer)
			if(countSum(playersCards) >= 21):
				playerDone.emit()


func _on_stand_button_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and canDraw:
		if event.pressed:
			playerDone.emit()

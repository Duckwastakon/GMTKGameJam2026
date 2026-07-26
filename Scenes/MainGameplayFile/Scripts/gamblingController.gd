extends Node3D

var playersCards: Array[int]
var opponentsCards: Array[int]

@export var Bob: Node3D

@export var playerCardContainer: Node3D
@export var opponentCardContainer: Node3D
@export var usedPile: Node3D
@onready var deckNode = $deck

const specialAbilities = ["destroy", "upgrade", "forcePickup", "downgrade", "checkNextCard", "checkOppCard", "skipNextLoss", "multi"]
var clickPower = ""

var deck = []

signal editInteractMessage
signal finishGame
signal playerDone

signal reachEndSignal
var reachedEnd = false

var betAmount = 0

var debt: int = 0

signal addBet
signal betChanged
signal startGame

signal distracted
signal cardDrawn

signal useItem
signal roundFinished

signal finishTutorial

var canDraw = false
var gameActive = false

var inTut = false

var distractVal = false

const cardScene = preload("res://Scenes/MainGameplayFile/ChildScenes/card.tscn")

@onready var allCards = $allPossibleCards.get_children()

var Specials = {
	"Two": 2,
	"Three": 3,
	"Four": 4,
	"Five": 5,
	"Six": 6,
	"Seven": 7,
	"Eight": 8,
	"Nine": 9,
	"Ten": 10,
	"Jack": 10,
	"Queen": 10,
	"King": 10,
	"Ace": 11
}

func shuffleDeck():
	deck.clear()
	
	for x in 4:
		for card in allCards:
			deck.append(card)
	
	for i in 256:
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
	
	
	print(playersCards)
	print(opponentsCards)
	
	await playerDone
	
	canDraw = false
	
	hiddenCard.showCard.emit()
	await get_tree().create_timer(1).timeout
	await opponentTurn()
	
	print("opponentFinished")
	
	distracted.emit(false)
	
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
	if(sumPlayer < 21):
		while(sumPlayer>sumOpponent and sumOpponent < 22):
			drawCard(opponentsCards, opponentCardContainer)
			await get_tree().create_timer(1).timeout
		
			sumPlayer = countSum(playersCards)
			sumOpponent = countSum(opponentsCards)
	print("done")

func countSum(arr):
	var num = 0
	var Ace = 0
	
	for n in arr:
		if n==11:
			Ace += 1
		else:
			num+=n
	
	while Ace>0:
		if num+11>21:
			num+=1
		else:
			num+=11
		
		Ace-=1
	
	return num

@onready var indArrow = $indicatorArrow


func _on_skip_pressed() -> void: # when skip tutorial button pressed - Niko
	inTut = false
	discardCards()
	indArrow.visible = false  
	finishTutorial.emit()
	Bob.clickToTalk = false
	Bob.clickNextString.emit()
	$cashDisplay.setEVisible(false)
	$"tutorial-skip".visible = false #skiptutorial button dissappears - Niko
	

func tutorial():
	$"tutorial-skip".visible = true #skiptutorial button appears - Niko
	$cashDisplay.setEVisible(true)
	inTut = true
	Bob.clickToTalk = true
	indArrow.visible = true
	indArrow.rotation_degrees = Vector3(0, -15, 0)
	indArrow.global_position = $importantDataDisplay.global_position + Vector3(0, 0.2, 0)
	Bob.talk("here you can see how
	far we are")
	await Bob.finishedTalking
	if not inTut: return # for skip tut
	var newTween = create_tween()
	newTween.tween_property(indArrow, "global_position", opponentCardContainer.global_position + Vector3(0, 0.3, 0), 1)
	newTween.play()
	indArrow.rotation = opponentCardContainer.rotation
	await newTween.finished
	if not inTut: return # for skip tut
	Bob.talk("The simple game of 21")
	drawCard(opponentsCards, opponentCardContainer)
	await get_tree().create_timer(0.5).timeout
	if not inTut: return # for skip tut
	drawCard(playersCards, playerCardContainer)
	await get_tree().create_timer(0.5).timeout
	if not inTut: return # for skip tut
	drawCard(opponentsCards, opponentCardContainer)
	await get_tree().create_timer(0.5).timeout
	if not inTut: return # for skip tut
	drawCard(playersCards, playerCardContainer)
	Bob.talk("the person whos cards add up closest to 21
	but don't go over wins")
	var playerSum = countSum(playersCards)
	var opponentsSum = countSum(opponentsCards)
	
	print(opponentsCards)
	Bob.talk("you have " + str(playerSum) + " points
	I have " + str(opponentsSum) + " points")
	
	if playerSum>=opponentsSum:
		Bob.talk("Here you would win")
	else:
		Bob.talk("Here I would win")
	
	Bob.talk("I will now turn to look away")
	Bob.talk("do NOT try to cheat when I am looking")
	await Bob.finishedTalking
	if not inTut: return # for skip tut
	Bob.startTut()
	distracted.emit(true)
	await cardDrawn
	print(opponentsCards)
	if not inTut: return # for skip tut
	Bob.StoppedDistract.emit()
	distracted.emit(false)
	Bob.talk("Hmm something changed")
	Bob.talk("whatever")
	await Bob.finishedTalking
	if not inTut: return # for skip tut
	
	discardCards()
	newTween = create_tween()
	newTween.tween_property(indArrow, "global_position", $betConsole.global_position + Vector3(0, 0.2, 0), 1)
	newTween.play()
	indArrow.rotation_degrees = Vector3(0, 15, 0)
	await newTween.finished
	if not inTut: return # for skip tut
	Bob.talk("Here click the buttons to change your bet amount")
	Bob.talk("Then click play to start the hand")
	await Bob.finishedTalking
	if not inTut: return # for skip tut
	finishTutorial.emit()
	Bob.clickToTalk = false
	Bob.clickNextString.emit()
	inTut = false
	$"tutorial-skip".visible = false #skiptutorial button dissappears - Niko
	$cashDisplay.setEVisible(false)


func drawCard(arr: Array[int], cont, hidden = false):
	$sounds/card.play()
	if(deck.size()<1):
		shuffleDeck()
	
	print(hidden)
	var newCard = cardScene.instantiate()
	newCard.setCard(deck[0].duplicate(), hidden, distractVal)
	cont.add_child(newCard)
	newCard.global_position = deckNode.global_position
	var cardName: String = deck[0].name
	var cardsValue = cardName.split("_")[1]
	var val = Specials[cardsValue]
	arr.append(val)
	deck.pop_at(0)
	
	cardDrawn.emit()
	connect("editInteractMessage", newCard.updateText)
	connect("distracted", newCard.setDistracted)
	newCard.connect("input_event", usePowerOnCard.bind(newCard, arr, arr.size() - 1, cont, newCard.cheat))
	newCard.connect("destroyCard", destroyCard.bind(newCard,arr, arr.size()-1,cont))
	return newCard

func discardCards() -> void:
	var cards = []
	cards.append_array(opponentCardContainer.get_children())
	cards.append_array(playerCardContainer.get_children())
	for card in cards:
		$sounds/card.play()
		card.reparent(usedPile)
		await get_tree().create_timer(0.5).timeout
	
	playersCards.clear()
	opponentsCards.clear()

func _ready() -> void:
	screenShake(100000)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	connect("addBet", betAdded)
	shuffleDeck()
	
	if Global.round == 0:
		tutorial()
		await finishTutorial
	else:
		finishTutorial.emit()
	while(!reachedEnd):
		while(!gameActive):
			await startGame
			if betAmount > 0:
				gameActive = true
			else:
				Bob.talk("You have to bet something")
		
		indArrow.visible = false
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
			Bob.loose()
			await get_tree().create_timer(3).timeout
			
			wonCash -= debt
			debt = 0
			Global.addCash(wonCash)
			$sounds/Getmney.play()
			betChanged.emit(0)
		else:
			betChanged.emit(0, true, "lost")
			Bob.win()
		
		betAmount = 0
		await discardCards()
		if Global.cash <= 0 and betAmount == 0:
			gameActive = false
			roundFinished.emit()
			looseGame()
			return
		
		if debt > 0:
			if Global.cash < debt:
				looseGame()
			else:
				Global.cash -= debt
				debt = 0
		gameActive = false
		
		roundFinished.emit()

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

signal nextLine

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("E"):
		#await drawCard(playersCards, playerCardContainer)
		#if(countSum(playersCards) >= 21):
			#playerDone.emit()
	
	#if event.is_action_pressed("Q") and canDraw:
		#playerDone.emit()


func _on_hit_button_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and canDraw:
		if event.pressed:
			$sounds/button.play(0.3)
			await drawCard(playersCards, playerCardContainer)
			if(countSum(playersCards) >= 21):
				playerDone.emit()


func _on_stand_button_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and canDraw:
		if event.pressed:
			$sounds/button.play(0.3)
			playerDone.emit()

func destroyCard(card: StaticBody3D, arr: Array, pos: int, cont):
	card.reparent(usedPile)
	arr.remove_at(pos)
	
	$sounds/card.play()
	drawCard(arr, cont, false)

func specialPower(power: String):
	if power == "forcePickup":
		useItem.emit()
		drawCard(opponentsCards, opponentCardContainer, false)
	elif power == "checkOpponentsCard":
		for c in opponentCardContainer.get_children():
			c.showCard.emit()
		useItem.emit()
	elif power == "multi":
		Global.nextCashBuff = 2.5
		useItem.emit()
	elif power == "skipNextLoss":
		Global.preventNextLoss = true
		useItem.emit()
		pass
	else:
		clickPower = power

func usePowerOnCard(_a, event: InputEvent, _c, _d, _e, card, arr: Array, pos: int, cont, cardSignal: Signal):
	if event is not InputEventMouseButton: return
	if event.pressed:
		if(clickPower=="destroy"):
			destroyCard(card, arr, pos, cont)
			useItem.emit()
		elif(clickPower=="upgrade"):
			var currentNum = arr[pos]
			if currentNum >= 11:
				currentNum = 2
			else:
				currentNum += 1
		
			arr[pos] = currentNum
			getCard(card, currentNum)
			
			useItem.emit()
		elif(clickPower=="downgrade"):
			var currentNum = arr[pos]
			if currentNum <= 1:
				currentNum = 11
			else:
				currentNum -= 1
			arr[pos] = currentNum
			getCard(card, currentNum)
			
			useItem.emit()
		else:
			cardSignal.emit(event)
		
		if clickPower != "":
			useItem.emit()
			editInteractMessage.emit("")
			clickPower = ""
	else:
		cardSignal.emit(event)

func getCard(card: StaticBody3D, num: int):
	var cardName: String
	for c in card.get_children():
		if c is MeshInstance3D:
			cardName = c.name
			break
	
	var splitName = cardName.split("_")
	var stringEnd: String
	for i in Specials:
		if Specials[i] == num:
			stringEnd = i
	
	var newString = splitName[0]+"_"+stringEnd
	var newCard = $allPossibleCards.get_node(newString)
	$allPossibleCards.get_node("CardClubs_Ace")
	for c in card.get_children():
		if c is MeshInstance3D:
			c.mesh = newCard.mesh

func looseGame():
	Bob.talk("well you have lost")
	Bob.talk("GET OFF")
	reachedEnd = true
	await Bob.finishedTalking
	TransitionController.ChangeScene("res://Scenes/MainGameplayFile/ChildScenes/main_menue.tscn")

func _on_reach_end_signal() -> void:
	reachedEnd = true
	
	if gameActive:
		Bob.talk("Last round")
		await roundFinished
	
	betAdded(-betAmount)
	
	Global.addCash(-debt)
	debt = 0
	if debt <= 0 and Global.cash > 5:
		Global.round = +1
		Bob.talk("hmmm, good job")
		await Bob.finishedTalking
		if Global.round < 3:
			TransitionController.ChangeScene("res://Scenes/MainGameplayFile/1_st_shop.tscn")
		else:
			TransitionController.ChangeScene("res://Scenes/MainGameplayFile/Scripts/ending.tscn")
	else:
		looseGame()

func bobTalk(str: String):
	Bob.talk(str)

func _on_distraction_timer_timeout() -> void:
	if gameActive:
		distracted.emit(true)
		distractVal = true
		await Bob.distract()
		distracted.emit(false)
		distractVal = false
	$distractionTimer.wait_time = randi_range(8, 26)
	$distractionTimer.start()

var screenShakeAmount = 0

func screenShake(amt: int):
	if screenShakeAmount == 0:
		screenShakeAmount += amt
		var shakeH
		var shakeV
		while(screenShakeAmount):
			shakeH = randf_range(-0.6, 0.6) * (Global.screenShake/100)
			shakeV = randf_range(-0.6, 0.6) * (Global.screenShake/100)
			
			for i in 5:
				$gamblingCam.h_offset = lerpf($gamblingCam.h_offset, shakeH, 0.1)
				$gamblingCam.v_offset = lerpf($gamblingCam.v_offset, shakeV, 0.1)
				await get_tree().create_timer(0.02).timeout
				
			screenShakeAmount -= 1
		
		$gamblingCam.h_offset = 0
		$gamblingCam.v_offset = 0
	else:
		screenShakeAmount += amt

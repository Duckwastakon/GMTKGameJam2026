extends Node3D

var playerCards = []
var aiCards = []

@export var playerCardContainer: Node3D
@export var aiCardContainer: Node3D
@export var usedPile: Node3D

var deck = []

signal finishGame

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
	for i in 2:
		drawCard(aiCards, aiCardContainer)
		await get_tree().create_timer(0.5).timeout
	
	for i in 2:
		drawCard(playerCards, playerCardContainer)
		await get_tree().create_timer(0.5).timeout
	
	await finishGame
	
	var playerSum: int = 0
	var aiSum: int = 0
	
	for num in playerCards:
		playerSum += num
	
	for num in aiCards:
		aiSum += num
	
	if(playerSum > aiSum):
		if(playerSum>21):
			return false
		return true
	if(aiSum>21):
		return true
	
	return false

func drawCard(arr, cont):
	var newCard = cardScene.instantiate()
	newCard.setText(str(deck[0]))
	cont.add_child(newCard)
	newCard.global_position = Vector3(0, 1, 0)
	print(deck[0])
	arr.append(deck[0])
	deck.pop_at(0)

func discardCards() -> void:
	var cards = []
	cards.append_array(aiCardContainer.get_children())
	cards.append_array(playerCardContainer.get_children())
	for card in cards:
		card.reparent(usedPile)
		await get_tree().create_timer(0.5).timeout
	
	playerCards.clear()
	aiCards.clear()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shuffleDeck()
	
	while(true):
		print(await playRound())
		
		await discardCards()
		print("roundDone")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("E"):
		drawCard(playerCards, playerCardContainer)
	
	if event.is_action_pressed("Q"):
		finishGame.emit()

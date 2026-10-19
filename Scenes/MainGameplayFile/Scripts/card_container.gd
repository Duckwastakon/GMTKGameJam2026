extends Node3D

const cardGap = Vector3(0.05, 0, 0)
const cardSize = Vector3(0.1, 0, 0)

const cardScene = preload("res://gameplay/components/card.tscn")

func _process(delta: float) -> void:
	var cards = get_children()
	var cardAmount = cards.size()
	
	var containerSize = (cardAmount - 1) * 0.15
	
	for i in cardAmount:
		var card = cards[i]
		var cardPos = cardGap * i + cardSize * i - Vector3(containerSize/ 2, -0.1, 0)
		card.position = lerp(card.position, cardPos, 0.2)

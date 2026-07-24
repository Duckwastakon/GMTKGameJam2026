extends Node

signal cashUpdated

var cash: int = 500
const maxItems: int = 3

var items: Array[Dictionary] = [
	{"name": "Scissors", "description": "Sharp and useful for cutting cards.", "price": 15},
	{"name": "Matches", "description": "A small box, good for lighting cards.", "price": 5},
	{"name": "Pen", "description": "Helps with rewriting a card.", "price": 3},
	{"name": "Deck", "description": "A deck of playing cards.", "price": 10},
	{"name": "Old coin", "description": "Might be worth something to a collector.", "price": 20},
	{"name": "Mask", "description": "hides your face = no facial cues.", "price": 25},
]

var shop_items: Dictionary = {}

func addCash(amount: int):
	cash += amount
	
	cashUpdated.emit(amount)

func compareCash(amount: int) -> bool:
	return (cash>amount)
	
func roll(shop_id: String) -> Array[Dictionary]:
	var pool_copy = items.duplicate()
	pool_copy.shuffle()
	var rolled: Array[Dictionary] = []
	for i in range(maxItems):
		if pool_copy.size() > 0:
			rolled.append(pool_copy.pop_front())
	shop_items[shop_id] = rolled
	return rolled

func getShopItems(shop_id: String) -> Array[Dictionary]:
	if shop_items.has(shop_id):
		return shop_items[shop_id]
	return []

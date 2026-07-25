extends Node

signal cashUpdated

var nextCashBuff: float = 1.0
var permanentCashBuff: float = 1.0
var cash: int = 500
const maxItems: int = 3

var boughtItems: Array[String]

var items: Array[Dictionary] = [
	{"name": "Scissors", "description": "You can cut a card in half, making Bob be forced to redraw it.", "price": 15},
	{"name": "Magic wand", "description": "+1 to a card or if on an ace -> 2.", "price": 5},
	{"name": "Gun", "description": "Forces Bob to draw a card in ANY scenario.", "price": 3},
	{"name": "Alcohol", "description": "Next round -> your wins or losses are 2.5 times bigger.", "price": 10},
	{"name": "Collectors coin", "description": "Can give at any loss and wont cause money to be taken away.", "price": 20},
	{"name": "Magnifying glass", "description": "Lets you see Bobs hidden card.", "price": 25},
]

var shop_items: Dictionary = {}

func addCash(amount: int):
	if amount>0:
		amount *= permanentCashBuff
	cash += amount * nextCashBuff
	
	nextCashBuff = 1.0
	
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

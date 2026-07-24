extends Node

signal cashUpdated

var cash: int = 500
const maxItems: int = 3

var items: Array[String] = [
	"Scissors", "Matches", "Pen", "Deck", "Old coin", "Mask"
]
var shop_items: Dictionary = {}

func addCash(amount: int):
	cash += amount
	
	cashUpdated.emit(amount)

func compareCash(amount: int) -> bool:
	return (cash>amount)
	
func roll(shop_id: String) -> Array[String]:
	var pool_copy = items.duplicate()
	pool_copy.shuffle()
	var rolled: Array[String] = []
	for i in range(maxItems):
		if pool_copy.size() > 0:
			rolled.append(pool_copy.pop_front())
	shop_items[shop_id] = rolled
	return rolled

func getShopItems(shop_id: String) -> Array[String]:
	if shop_items.has(shop_id):
		return shop_items[shop_id]
	return []

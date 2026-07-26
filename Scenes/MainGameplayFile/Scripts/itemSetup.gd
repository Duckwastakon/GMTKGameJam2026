extends Node3D

var items: Array[Dictionary] = [
	{"name": "Scissors", "description": "You can cut a card in half, making Bob be forced to redraw it.", "price": 15},
	{"name": "Magic wand", "description": "+1 to a card or if on an ace -> 2.", "price": 5},
	{"name": "Gun", "description": "Forces Bob to draw a card in ANY scenario.", "price": 3},
	{"name": "Alcohol", "description": "Next round -> your wins or losses are 2.5 times bigger.", "price": 10},
	{"name": "Collectors coin", "description": "Can give at any loss and wont cause money to be taken away.", "price": 20},
	{"name": "Magnifying glass", "description": "Lets you see Bobs hidden card.", "price": 25},
]

func _ready() -> void:
	var i = 0
	for item in Global.boughtItems:
		print(i)
		get_child(i).setItem(item)
		i+=1

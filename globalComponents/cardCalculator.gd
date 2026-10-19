extends Node

var cardPowers = {
	"Two": {
		"addAmount": 0,
		"addMultiplier": 2,
		},
	"Three": {
		"addAmount": 1,
		"addMultiplier": 2,
		},
	"Four": {
		"addAmount": 4,
		"addMultiplier": 0,
		},
	"Five": {
		"addAmount": 5,
		"addMultiplier": 0,
		},
	"Six": {
		"addAmount": 6,
		"addMultiplier": 0,
		},
	"Seven": {
		"addAmount": 7,
		"addMultiplier": 0,
		},
	"Eight": {
		"addAmount": 8,
		"addMultiplier": 0,
		},
	"Nine": {
		"addAmount": 9,
		"addMultiplier": 0,
		},
	"Ten": {
		"addAmount": 10,
		"addMultiplier": 0,
		},
	"Jack": {
		"addAmount": 10,
		"addMultiplier": 0,
		},
	"Queen": {
		"addAmount": 10,
		"addMultiplier": 0,
		},
	"King": {
		"addAmount": 10,
		"addMultiplier": 0,
		},
	"Ace": {
		"addAmount": 20,
		"addMultiplier": 2,
		},
	}

var symbolPowers = {
	"Hearts": {
		"addAmount": 0,
		"addMultiplier": 0,
	},
	"Diamonds": {
		"addAmount": 0,
		"addMultiplier": 0,
	},
	"Clubs": {
		"addAmount": 0,
		"addMultiplier": 0,
	},
	"Spades": {
		"addAmount": 0,
		"addMultiplier": 0,
	},
}

var amount = 0
var multiplier = 1

func calculateAmount(selectedCards):
	amount = 0
	multiplier = 1
	
	var delayTime = 0.3
	var delayTimes = 0
	
	for card in selectedCards:
		var cardValues = card.values
		
		for possibleAddition in cardPowers[cardValues[1]]:
			var functionAmount = cardPowers[cardValues[1]][possibleAddition]
			if functionAmount != 0:
				call(possibleAddition, functionAmount, card)
				
				await get_tree().create_timer(delayTime).timeout
				
				delayTimes += 1
				if delayTimes >= 10:
					delayTime /= 2
					delayTimes = 0
	
	
	return amount * multiplier

func addAmount(val, card):
	amount += val
	card.cardUsed([str(val), Color(0.0, 0.788, 0.886, 1.0)], 1)

func addMultiplier(val, card):
	multiplier += val
	card.cardUsed([str(val), Color(0.959, 0.552, 0.547, 1.0)], 1)

extends Node

signal updateCash
signal selectCard

signal updateAmount
signal updateMultiplier

signal buyCard
signal rerollCards

signal updateTokens
signal setRerollPrice
signal setNeededScore

signal setLevel

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

var extraFunctions = {
	0: {
		
	},
	1:{
		
	}
}

func addPowerUp(id, card):
	var powerUps = Global.powerId[id]["powers"]
	for type in powerUps:
		if(cardPowers.has(type)):
			for new in powerUps[type]:
				if cardPowers[type].has(new):
					cardPowers[type][new] += powerUps[type][new]
				else:
					cardPowers[type][new] = powerUps[type][new]
		elif(symbolPowers.has(type)):
			for new in powerUps[type]:
				if symbolPowers[type].has(new):
					symbolPowers[type][new] += powerUps[type][new]
				else:
					symbolPowers[type][new] = powerUps[type][new]
		else:
			if(powerUps[type]["before"]):
				if(extraFunctions[0].has(type)):
					var newVars = powerUps[type]["vars"].duplicate(true)
					newVars[1].append(card)
					extraFunctions[0][type].append(newVars)
				else:
					var newVars = powerUps[type]["vars"].duplicate(true)
					newVars[1].append(card)
					extraFunctions[0].set(type, [newVars])
			else:
				if(extraFunctions[1].has(type)):
					var newVars = powerUps[type]["vars"].duplicate(true)
					newVars[1].append(card)
					extraFunctions[1][type].append(newVars)
				else:
					var newVars = powerUps[type]["vars"].duplicate(true)
					newVars[1].append(card)
					extraFunctions[1].set(type, [newVars])

var amount = 0
var multiplier = 1
var repeatedTimes = 1
var currentCards = []

func calculateAmount(selectedCards):
	amount = 0
	multiplier = 1
	repeatedTimes = 1
	currentCards = selectedCards
	
	var delayTime = 0.5
	var delayTimes = 0
	
	var afterFunctions = {}
	
	for funcName in extraFunctions[0]:
		print(funcName)
	
	for x in repeatedTimes:
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
			for possibleAddition in symbolPowers[cardValues[0]]:
				var functionAmount = symbolPowers[cardValues[0]][possibleAddition]
				if functionAmount != 0:
					call(possibleAddition, functionAmount, card)
				
					await get_tree().create_timer(delayTime).timeout
				
					delayTimes += 1
					if delayTimes >= 10:
						delayTime /= 2
						delayTimes = 0
	
	for funcName in extraFunctions[1]:
		for val in extraFunctions[1][funcName]:
			call(funcName, val)
			
			await get_tree().create_timer(delayTime).timeout
	
	return amount * multiplier

func addAmount(val, card):
	amount += val
	card.cardUsed([str(val), Color(0.0, 0.788, 0.886, 1.0)], 1)
	updateAmount.emit(amount)

func addMultiplier(val, card):
	multiplier += val
	card.cardUsed([str(val), Color(0.959, 0.552, 0.547, 1.0)], 1)
	updateMultiplier.emit(multiplier)

func multiplyMultiplier(val, card):
	multiplier *= val
	card.cardUsed([str(val), Color(0.959, 0.552, 0.547, 1.0)], 1)
	updateMultiplier.emit(multiplier)

func countSum(val):
	
	call(val[1][0], val[1][1], val[1][2])

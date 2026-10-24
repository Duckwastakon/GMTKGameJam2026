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

var chipAudio = "res://sfx/keyboardClick.mp3"

var cardPowers = {
	"Two": {
		"addMultiplier": 2,
		},
	"Three": {
		"addAmount": 3,
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
		"addAmount": 10,
		"addMultiplier": 1,
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

var stringToInt = {
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
	"Ace": 11,
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
var delayTimes = 0

func calculateAmount(selectedCards):
	amount = 0
	multiplier = 1
	repeatedTimes = 1
	currentCards = selectedCards
	
	var delayTime = 0.5
	delayTimes = 0
	
	var afterFunctions = {}
	
	for funcName in extraFunctions[0]:
		for val in extraFunctions[0][funcName]:
			call(funcName, val)
			
			await get_tree().create_timer(delayTime).timeout
			delayTimes += 1
			if delayTimes%10==0:
				delayTime /= 2
	
	for x in repeatedTimes:
		for card in selectedCards:
			var cardValues = card.values
		
			for possibleAddition in cardPowers[cardValues[1]]:
				var functionAmount = cardPowers[cardValues[1]][possibleAddition]
				if functionAmount != 0:
					call(possibleAddition, functionAmount, card)
				
					await get_tree().create_timer(delayTime).timeout
				
					delayTimes += 1
					if delayTimes%10==0:
						delayTime /= 2
			for possibleAddition in symbolPowers[cardValues[0]]:
				var functionAmount = symbolPowers[cardValues[0]][possibleAddition]
				if functionAmount != 0:
					call(possibleAddition, functionAmount, card)
				
					await get_tree().create_timer(delayTime).timeout
				
					delayTimes += 1
					if delayTimes%10==0:
						delayTime /= 2
	
	for funcName in extraFunctions[1]:
		for val in extraFunctions[1][funcName]:
			call(funcName, val)
			
			await get_tree().create_timer(delayTime).timeout
			delayTimes += 1
			if delayTimes%10==0:
				delayTime /= 2
	
	return amount * multiplier

func addAmount(val, card):
	amount += val
	var shortened = shortenAmount(val)
	card.cardUsed([str(shortened[0]) + shortened[1], Color(0.0, 0.788, 0.886, 1.0)], 1)
	AudioSystem.playSFX(chipAudio, 1 + sqrt(delayTimes)/3, 16)
	updateAmount.emit(amount)

func multiplyAmount(val, card):
	amount *= val
	var shortened = shortenAmount(val)
	card.cardUsed([str(shortened[0]) + shortened[1], Color(0.0, 0.788, 0.886, 1.0)], 1)
	AudioSystem.playSFX(chipAudio)
	updateMultiplier.emit(multiplier)

func addMultiplier(val, card):
	multiplier += val
	var shortened = shortenAmount(val)
	card.cardUsed([str(shortened[0]) + shortened[1], Color(0.959, 0.552, 0.547, 1.0)], 1)
	AudioSystem.playSFX(chipAudio, 1 + sqrt(delayTimes)/3, 16)
	updateMultiplier.emit(multiplier)

func multiplyMultiplier(val, card):
	multiplier *= val
	var shortened = shortenAmount(val)
	card.cardUsed([str(shortened[0]) + shortened[1], Color(0.959, 0.552, 0.547, 1.0)], 1)
	AudioSystem.playSFX(chipAudio)
	updateMultiplier.emit(multiplier)

func addRepeated(val, card):
	repeatedTimes += val
	var shortened = shortenAmount(val)
	card.cardUsed([str(shortened[0]) + shortened[1], Color(0.959, 0.552, 0.547, 1.0)], 1)
	AudioSystem.playSFX(chipAudio)

func switchValues(val, card):
	var savedVal = amount
	amount = multiplier
	multiplier = savedVal
	var shortened = shortenAmount(amount)
	card.cardUsed([str(shortened[0]) + shortened[1], Color(0.959, 0.552, 0.547, 1.0)], 1)
	AudioSystem.playSFX(chipAudio)
	updateMultiplier.emit(multiplier)
	updateAmount.emit(amount)

func countSum(val):
	var sum = 0
	for card in currentCards:
		sum += stringToInt[card.values[1]]
	
	if sum == val[0]:
		call(val[1][0], val[1][1], val[1][2])

func compareSumUnder(val):
	var sum = 0
	for card in currentCards:
		sum += stringToInt[card.values[1]]
	
	if sum < val[0]:
		call(val[1][0], val[1][1], val[1][2])

func compareSumOver(val):
	var sum = 0
	for card in currentCards:
		sum += stringToInt[card.values[1]]
	
	if sum > val[0]:
		call(val[1][0], val[1][1], val[1][2])

func countCardAmount(val):
	if(currentCards.size() == val[0]):
		call(val[1][0], val[1][1], val[1][2])

func checkCardType(val):
	for card in currentCards:
		if card.values[0] == val[0]:
			call(val[1][0], val[1][1], val[1][2])
			return

func checkCardNumber(val):
	for card in currentCards:
		if  card.values[1] == val[0]:
			call(val[1][0], val[1][1], val[1][2])
			return

func checkAllNumberBelow(val):
	for card in currentCards:
		if stringToInt[card.values[1]] >= val[0]:
			return
	
	call(val[1][0], val[1][1], val[1][2])

func checkAllNumberAbove(val):
	for card in currentCards:
		if stringToInt[card.values[1]] <= val[0]:
			return
	
	call(val[1][0], val[1][1], val[1][2])

func doFunction(val):
	call(val[1][0], val[1][1], val[1][2])

func checkCardTypesEqual(val):
	var currentType = null
	for card in currentCards:
		if currentType == null:
			currentType = card.values[0]
		else:
			if card.values[0] != currentType:
				return
	
	call(val[1][0], val[1][1], val[1][2])

var shorter = ["", "K", "M", "B", "T", "Qa", "Qi"]

func shortenAmount(amount):
	var i = 0
	amount = float(amount)
	while(amount / 1000 > 1):
		amount /= 1000
		i+=1
	var newAmount = (round(amount * pow(10.0, 2)) / pow(10.0, 2))
	if (int(newAmount) == newAmount):
		newAmount = roundi(newAmount)
	return [newAmount, shorter[clampi(i, 0, 6)]]

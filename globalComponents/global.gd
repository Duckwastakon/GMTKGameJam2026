extends Node

var storyMode = false

var powerId = {
	0: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_03.png",
		"txt": "all 3 cards give +1 multiplier",
		"price": 3,
		"powers": {
			"Three": {
				"addMultiplier": 1,
			},
		}
	},
	1: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_A.png",
		"txt": "all heart cards give +1 amount",
		"price": 5,
		"powers": {
			"Hearts": {
				"addAmount": 1,
			}
		}
	},
	2: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_A.png",
		"txt": "double your multiplier if the card sum is 10",
		"price": 5,
		"powers": {
			"countSum": {
				"vars": [10, ["multiplyMultiplier", 2]],
				"before": false
			}
		}
	}
}

var volume = 50
var screenShake = 50
var sensitivity = 50

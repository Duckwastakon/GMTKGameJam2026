extends Node

var storyMode = false

var powerId = {
	0: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_back.png",
		"txt": "make your hand cards activate twice",
		"price": 8,
		"powers": {
			"doFunction": {
				"vars": ["", ["addRepeated", 1]],
				"before": true
			}
		}
	},
	1: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_02.png",
		"txt": "all 2 cards give +1 multiplier",
		"price": 1,
		"powers": {
			"Two": {
				"addMultiplier": 1,
			},
		}
	},
	2: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_03.png",
		"txt": "get +2 multiplier if you use 3 cards in your hand",
		"price": 3,
		"powers": {
			"countCardAmount": {
				"vars": [3, ["addMultiplier", 2]],
				"before": false
			},
		}
	},
	3: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_04.png",
		"txt": "All clubs give +1 multiplier",
		"price": 2,
		"powers": {
			"Clubs": {
				"addMultiplier": 1,
			}
		}
	},
	4: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_05.png",
		"txt": "all card types below 6 gain +3 amount and +1 multiplier",
		"price": 3,
		"powers": {
			"Two": {
				"addMultiplier": 1,
				"addAmount": 3,
			},
			"Three": {
				"addMultiplier": 1,
				"addAmount": 3,
			},
			"Four": {
				"addMultiplier": 1,
				"addAmount": 3,
			},
			"Five": {
				"addMultiplier": 1,
				"addAmount": 3,
			},
		}
	},
	5: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_06.png",
		"txt": "2x multiplier if all card values are under 6",
		"price": 2,
		"powers": {
			"checkAllNumberBelow": {
				"vars": [6, ["multiplyMultiplier", 2]],
				"before": false
			}
		}
	},
	6: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_07.png",
		"txt": "3x multiplier if you play a 7",
		"price": 7,
		"powers": {
			"checkCardNumber": {
				"vars": ["Seven", ["multiplyMultiplier", 3]],
				"before": false
			}
		}
	},
	7: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_08.png",
		"txt": "6, 7 and 8 cards give +8 amount",
		"price": 2,
		"powers": {
			"Six": {
				"addAmount": 8,
			},
			"Seven": {
				"addAmount": 8,
			},
			"Eight": {
				"addAmount": 8,
			}
		}
	},
	8: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_09.png",
		"txt": "Get +9 multiplier every round",
		"price": 9,
		"powers": {
			"doFunction": {
				"vars": ["", ["addMultiplier", 9]],
				"before": true
			}
		}
	},
	9: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_10.png",
		"txt": "5x multiplier if the card sum is 10",
		"price": 5,
		"powers": {
			"countSum": {
				"vars": [10, ["multiplyMultiplier", 5]],
				"before": true
			}
		}
	},
	10: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_A.png",
		"txt": "all aces give +20 amount",
		"price": 4,
		"powers": {
			"Ace": {
				"addAmount": 20,
			}
		}
	},
	11: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_J.png",
		"txt": "2x multiplier if all cards are higher than a 9",
		"price": 3,
		"powers": {
			"checkAllNumberAbove": {
				"vars": [9, ["multiplyMultiplier", 2]],
				"before": true
			}
		}
	},
	12: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_K.png",
		"txt": "all kings give +2 multiplier",
		"price": 2,
		"powers": {
			"King": {
				"addMultiplier": 2,
			},
		}
	},
	13: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_clubs_Q.png",
		"txt": "all face cards give +5 amount",
		"price": 3,
		"powers": {
			"Jack": {
				"addAmount": 5,
				},
			"Queen": {
				"addAmount": 5,
				},
			"King": {
				"addAmount": 5,
				},
			"Ace": {
				"addAmount": 5,
			},
		}
	},
	14: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_02.png",
		"txt": "+2 multiplier every round",
		"price": 3,
		"powers": {
			"doFunction": {
				"vars": ["", ["addMultiplier", 2]],
				"before": true
			}
		}
	},
	15: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_03.png",
		"txt": "all 3 cards give +3 multiplier",
		"price": 2,
		"powers": {
			"Three": {
				"addMultiplier": 3
			}
		}
	},
	16: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_04.png",
		"txt": "2x multiplier if you play a 4 card",
		"price": 4,
		"powers": {
			"checkCardNumber": {
				"vars": ["Four", ["multiplyMultiplier", 2]],
				"before": false
			}
		}
	},
	17: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_05.png",
		"txt": "5x multiplier if all card values are below 5",
		"price": 5,
		"powers": {
			"checkAllNumberBelow": {
				"vars": [5, ["multiplyMultiplier", 5]],
				"before": false
			}
		}
	},
	18: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_06.png",
		"txt": "+20 amount every round",
		"price": 2,
		"powers": {
			"doFunction": {
				"vars": [5, ["addAmount", 20]],
				"before": false
			}
		}
	},
	19: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_07.png",
		"txt": "all diamond cards give +1 multiplier",
		"price": 2,
		"powers": {
			"Diamonds": {
				"addMultiplier": 1,
			}
		}
	},
	20: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_08.png",
		"txt": "all diamond cards give +8 amount",
		"price": 2,
		"powers": {
			"Diamonds": {
				"addAmount": 8,
			}
		}
	},
	21: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_09.png",
		"txt": "3x multiplier if all card suits are the same",
		"price": 4,
		"powers": {
			"checkCardTypesEqual": {
				"vars": ["", ["multiplyMultiplier", 3]],
				"before": false
			}
		}
	},
	22: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_10.png",
		"txt": "all 10 cards give +10 multiplier",
		"price": 7,
		"powers": {
			"Ten": {
				"addMultiplier": 10,
			}
		}
	},
	23: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_A.png",
		"txt": "2x multiplier if you play a diamonds card",
		"price": 5,
		"powers": {
			"checkCardType": {
				"vars": ["Diamonds", ["multiplyMultiplier", 2]],
				"before": false
			}
		}
	},
	24: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_J.png",
		"txt": "all number cards give +6 amount",
		"price": 3,
		"powers": {
			"Two": {
				"addAmount": 6,
			},
			"Three": {
				"addAmount": 6,
			},
			"Four": {
				"addAmount": 6,
			},
			"Five": {
				"addAmount": 6,
			},
			"Six": {
				"addAmount": 6,
			},
			"Seven": {
				"addAmount": 6,
			},
			"Eight": {
				"addAmount": 6,
			},
			"Nine": {
				"addAmount": 6,
			},
			"Ten": {
				"addAmount": 6,
			},
		}
	},
	25: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_K.png",
		"txt": "card activate one more time if you play a diamond card",
		"price": 6,
		"powers": {
			"checkCardType": {
				"vars": ["Diamonds", ["addRepeated", 1]],
				"before": true
			}
		}
	},
	26: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_diamonds_Q.png",
		"txt": "face cards give -5 amount, but +1 multiplier",
		"price": 2,
		"powers": {
			"Jack": {
				"addAmount": -5,
				"addMultiplier": 1,
			},
			"Queen": {
				"addAmount": -5,
				"addMultiplier": 1,
			},
			"King": {
				"addAmount": -5,
				"addMultiplier": 1,
			},
			"Ace": {
				"addAmount": -5,
				"addMultiplier": 1,
			},
		}
	},
	27: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_empty.png",
		"txt": "cards activate 5 more times if you play one card",
		"price": 5,
		"powers": {
			"countCardAmount": {
				"vars": [1, ["addRepeated", 5]],
				"before": true
			}
		}
	},
	28: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_02.png",
		"txt": "all cards 2-7 give +10 amount and +1 multiplier",
		"price": 4,
		"powers": {
			"Two": {
				"addAmount": 10,
				"addMultiplier": 1,
			},
			"Three": {
				"addAmount": 10,
				"addMultiplier": 1,
			},
			"Four": {
				"addAmount": 10,
				"addMultiplier": 1,
			},
			"Five": {
				"addAmount": 10,
				"addMultiplier": 1,
			},
			"Six": {
				"addAmount": 10,
				"addMultiplier": 1,
			},
			"Seven": {
				"addAmount": 10,
				"addMultiplier": 1,
			},
		}
	},
	29: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_03.png",
		"txt": "+20 amount if you play 3 cards",
		"price": 2,
		"powers": {
			"countCardAmount": {
				"vars": [3, ["addAmount", 20]],
				"before": false
			}
		}
	},
	30: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_04.png",
		"txt": "all 4 cards give +1 multiplier",
		"price": 1,
		"powers": {
			"Four": {
				"addMultiplier": 1,
			}
		}
	},
	31: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_05.png",
		"txt": "5x multiplier If the card sum is 5 or less",
		"price": 5,
		"powers": {
			"compareSumUnder": {
				"vars": [6, ["multiplyMultiplier", 5]],
				"before": false
			}
		}
	},
	32: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_06.png",
		"txt": "all cards give +6 amount",
		"price": 3,
		"powers": {
			"Two": {
				"addMultiplier": 6,
				},
			"Three": {
				"addAmount": 6,
			},
			"Four": {
				"addAmount": 6,
			},
			"Five": {
				"addAmount": 6,
				},
			"Six": {
				"addAmount": 6,
			},
			"Seven": {
				"addAmount": 6,
			},
			"Eight": {
				"addAmount": 6,
				},
			"Nine": {
				"addAmount": 6,
			},
			"Ten": {
				"addAmount": 6,
			},
			"Jack": {
				"addAmount": 6,
			},
			"Queen": {
				"addAmount": 6,
			},
			"King": {
				"addAmount": 6,
			},
			"Ace": {
				"addAmount": 6,
			},
		}
	},
	33: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_07.png",
		"txt": "7x multiplier If the card sum is 7",
		"price": 5,
		"powers": {
			"countSum": {
				"vars": [7, ["multiplyMultiplier", 7]],
				"before": false
			}
		}
	},
	34: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_08.png",
		"txt": "all 8 cards give +10 amount",
		"price": 1,
		"powers": {
			"Eight": {
				"addAmount": 10
			}
		}
	},
	35: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_09.png",
		"txt": "3, 6 and 9 cards give +3 multiplier",
		"price": 5,
		"powers": {
			"Three": {
				"addMultiplier": 3
			},
			"Six": {
				"addMultiplier": 3
			},
			"Nine": {
				"addMultiplier": 3
			},
		}
	},
	36: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_10.png",
		"txt": "all hearts cards give +10 amount",
		"price": 2,
		"powers": {
			"Hearts": {
				"addAmount": 10
			}
		}
	},
	37: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_A.png",
		"txt": "cards activate 1 more time if you play a hearts card",
		"price": 7,
		"powers": {
			"checkCardType": {
				"vars": ["Hearts", ["addRepeated", 1]],
				"before": true
			}
		}
	},
	38: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_J.png",
		"txt": "jacks give -10 amount, but +3 multiplier",
		"price": 1,
		"powers": {
			"Jack": {
				"addAmount": -10,
				"addMultiplier": 3,
			}
		}
	},
	39: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_K.png",
		"txt": "cards activate 1 more time if you play a king",
		"price": 3,
		"powers": {
			"checkCardNumber": {
				"vars": ["King", ["addRepeated", 1]],
				"before": true
			}
		}
	},
	40: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_hearts_Q.png",
		"txt": "cards activate 1 more time if you play only cards lower than a 10",
		"price": 3,
		"powers": {
			"checkAllNumberBelow": {
				"vars": [10, ["addRepeated", 1]],
				"before": true
			}
		}
	},
	41: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_joker_black.png",
		"txt": "loose 10 multiplier each hand",
		"price": -20,
		"powers": {
			"doFunction": {
				"vars": [4, ["addMultiplier", -10]],
				"before": true
			}
		}
	},
	42: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_joker_red.png",
		"txt": "loose 30 amount each hand",
		"price": -20,
		"powers": {
			"doFunction": {
				"vars": [4, ["addAmount", -30]],
				"before": true
			}
		}
	},
	43: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_02.png",
		"txt": "all spade cards give +2 multiplier",
		"price": 3,
		"powers": {
			"Spades": {
				"addMultiplier": 2,
			}
		}
	},
	44: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_03.png",
		"txt": "all spade cards give +3 amount",
		"price": 1,
		"powers": {
			"Spades": {
				"addAmount": 3,
			}
		}
	},
	45: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_04.png",
		"txt": "4x multiplier if you play a 4 card",
		"price": 8,
		"powers": {
			"checkCardNumber": {
				"vars": ["Four", ["multiplyMultiplier", 4]],
				"before": false
			}
		}
	},
	46: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_05.png",
		"txt": "Ace cards give -10 amount, but 5 and 10 cards give +1 multiplier",
		"price": 1,
		"powers": {
			"Ace": {
				"addAmount": -10,
			},
			"Ten": {
				"addMultiplier": 1,
			},
			"Five": {
				"addMultiplier": 1,
			}
		}
	},
	47: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_06.png",
		"txt": "all 6 cards give +6 multiplier",
		"price": 6,
		"powers": {
			"Six": {
				"addMultiplier": 6,
			},
		}
	},
	48: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_07.png",
		"txt": "all 7 cards give +7 multiplier",
		"price": 7,
		"powers": {
			"Seven": {
				"addMultiplier": 7,
			},
		}
	},
	49: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_08.png",
		"txt": "2x multiplier if the card sum is more than 8",
		"price": 4,
		"powers": {
			"compareSumOver": {
				"vars": [8, ["multiplyMultiplier", 2]],
				"before": false
			}
		}
	},
	50: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_09.png",
		"txt": "All spade cards give +3 multiplier",
		"price": 5,
		"powers": {
			"Spades": {
				"addMultiplier": 3,
			}
		}
	},
	51: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_10.png",
		"txt": "All spade cards give +10 amount",
		"price": 6,
		"powers": {
			"Spades": {
				"addAmount": 10,
			}
		}
	},
	52: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_A.png",
		"txt": "3x amount if the card sum is 30",
		"price": 5,
		"powers": {
			"countSum": {
				"vars": [30, ["multiplyAmount", 3]],
				"before": false
			}
		}
	},
	53: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_J.png",
		"txt": "5x the amount if the card sum is 14",
		"price": 5,
		"powers": {
			"countSum": {
				"vars": [14, ["multiplyAmount", 5]],
				"before": false
			}
		}
	},
	54: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_K.png",
		"txt": "cards activate 1 more time if you play only one card suit",
		"price": 3,
		"powers": {
			"checkCardTypesEqual": {
				"vars": ["", ["addRepeated", 1]],
				"before": true
			}
		}
	},
	55: {
		"img": "res://gameplay/artAssestsAndModels/2dCardArt/card_spades_Q.png",
		"txt": "queen cards give +5 multiplier",
		"price": 3,
		"powers": {
			"Queen": {
				"addMultiplier": 5
			}
		}
	},
}

var volume = 50
var screenShake = 50
var sensitivity = 50

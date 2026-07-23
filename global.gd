extends Node

signal cashUpdated

var cash: int = 500
var items: Array[String]
const maxItems: int = 3

func addCash(amount: int):
	cash += amount
	
	cashUpdated.emit(amount)

func compareCash(amount: int) -> bool:
	return (cash>amount)

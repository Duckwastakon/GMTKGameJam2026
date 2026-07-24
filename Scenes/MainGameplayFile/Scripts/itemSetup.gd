extends Node3D


var item_Abilities_Models = {
	"Scissors" = "destroy",
	
}
func _ready() -> void:
	for item in Global.shop_items:
		print(item)
		
		var itemStats = item_Abilities_Models[item]
		if itemStats == null:
			return
		

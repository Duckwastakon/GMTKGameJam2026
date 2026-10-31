extends Node3D

const backgrounds = ["res://gameplay/components/road.tscn", "res://gameplay/components/ocean.tscn", "res://gameplay/components/train.tscn"]
var curretBackground = 0
func newBackground(val = true):
	if val:
		var randNum = randi_range(0, backgrounds.size()-1)
		while  randNum == curretBackground:
			randNum = randi_range(0, backgrounds.size()-1)
		curretBackground = randNum
		var randBackground = backgrounds[randNum]
		for child in get_children():
			child.queue_free()
		
		var newChild = load(randBackground).instantiate()
		add_child(newChild)
		newChild.position = Vector3.ZERO
	else:
		var randBackground = backgrounds[curretBackground + 1]
		curretBackground += 1
		for child in get_children():
			child.queue_free()
		
		var newChild = load(randBackground).instantiate()
		add_child(newChild)
		newChild.position = Vector3.ZERO
		
		await get_tree().create_timer(1)
		if(curretBackground == 1):
			get_parent().Bob.talk("How far is your house?")
		else:
			get_parent().Bob.talk("We are close to home")

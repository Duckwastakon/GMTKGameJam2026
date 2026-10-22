extends Node3D

@onready var tree = $"tree-large2"
@onready var rock = $"rocks-c"

func _on_obstacle_timeout() -> void:
	var newObj = tree.duplicate()
	add_child(newObj)
	var p = randi_range(-1, 1)
	while p==0:
		p = randi_range(-1, 1)
	var pos = Vector3(randi_range(8, 16) * p,randi_range(-1.8, -1.5), -48)
	newObj.position = pos
	newObj.rotation.y = randi_range(-45, 45)
	newObj.scale = Vector3(1,1,1) * randf_range(5, 15)
	
	var tweenTime = 3
	var newMoveTween = create_tween()
	newMoveTween.tween_property(newObj, "position", pos * Vector3(1, 1, -0.2), tweenTime)
	newMoveTween.play()
	await newMoveTween.finished
	newObj.queue_free()


func _on_rock_timeout() -> void:
	var newObj = rock.duplicate()
	add_child(newObj)
	var p = randi_range(-1, 1)
	while p==0:
		p = randi_range(-1, 1)
	var pos =Vector3(randi_range(8, 12) * p,randi_range(-1.8, -1.5), -48)
	newObj.position = pos
	newObj.rotation.y = randi_range(-45, 45)
	newObj.scale = Vector3(1,1,1) * randf_range(0.8, 1.5)
	
	var tweenTime = 3
	var newMoveTween = create_tween()
	newMoveTween.tween_property(newObj, "position", pos * Vector3(1, 1, -0.2), tweenTime)
	newMoveTween.play()
	await newMoveTween.finished
	newObj.queue_free()

@onready var cars = $cars

func _on_car_timer_timeout() -> void:
	var newObj = cars.get_child(randi_range(0, cars.get_child_count() - 1)).duplicate()
	add_child(newObj)
	var pos = Vector3(-3.5, -1, -45)
	newObj.position = pos
	
	var tweenTime = 1.5
	var newMoveTween = create_tween()
	newMoveTween.tween_property(newObj, "position", pos * Vector3(1, 1, -0.2), tweenTime)
	newMoveTween.play()
	await newMoveTween.finished
	newObj.queue_free()
	$carTimer.start(randf_range(3, 5))

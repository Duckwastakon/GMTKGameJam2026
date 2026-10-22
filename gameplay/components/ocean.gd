extends Node3D

@onready var shipwreck = $"ship-wreck"

func _on_boat_timer_timeout() -> void:
	var p = randi_range(-1, 1)
	while p==0:
		p = randi_range(-1, 1)
	var pos =Vector3(randi_range(8, 12) * p,randi_range(-2, -1), -48)
	shipwreck.position = pos
	shipwreck.rotation.y = randi_range(-45, 45)
	shipwreck.scale = Vector3(1,1,1) * randf_range(0.7, 1.2)
	
	var tweenTime = randf_range(20, 30)
	var newMoveTween = create_tween()
	newMoveTween.tween_property(shipwreck, "position", pos * Vector3(1, 1, -0.2), tweenTime)
	newMoveTween.play()
	await newMoveTween.finished
	$boatTimer.start(randi_range(8, 12))

@onready var rock = $"rocks-c"

func _on_rock_timer_timeout() -> void:
	var p = randi_range(-1, 1)
	while p==0:
		p = randi_range(-1, 1)
	var pos =Vector3(randi_range(5, 12) * p,randi_range(-1, -0.1), -48)
	rock.position = pos
	rock.rotation.y = randi_range(-45, 45)
	rock.scale = Vector3(1,1,1) * randf_range(1.25, 1.5)
	
	var tweenTime = randf_range(20, 30)
	var newMoveTween = create_tween()
	newMoveTween.tween_property(rock, "position", pos * Vector3(1, 1, -0.2), tweenTime)
	newMoveTween.play()
	await newMoveTween.finished
	$rockTimer.start(randi_range(4, 6))

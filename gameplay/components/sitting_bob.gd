extends Node3D

@onready var talkingLabel = $Label3D
@onready var Anims = $AnimationPlayer
var idleAnims = ["idle", "sitting1"]
var distractionAnims = ["distracted", "distracted2", "distracted3"]

var currentIdleAnim: String

var textQueue: Array[String]

signal finishedTalking
signal StoppedDistract

func win():
	Anims.stop()
	Anims.play("win")

func loose():
	Anims.stop()
	Anims.play("loose")

func changeIdleAnimation():
	var randIdle = randi_range(0, idleAnims.size() -1)
	if Anims.current_animation == currentIdleAnim:
		currentIdleAnim = idleAnims[randIdle]
		Anims.play(currentIdleAnim)
	else:
		currentIdleAnim = idleAnims[randIdle]
	
	print("changed to " + idleAnims[randIdle])

func playIdle(currentAnim):
	Anims.play(currentIdleAnim)

func _ready() -> void:
	Anims.play("sitDown")
	await Anims.animation_finished
	Anims.connect("animation_finished", playIdle)
	var randIdle = randi_range(0, idleAnims.size() - 1)
	currentIdleAnim = idleAnims[randIdle]
	Anims.play(currentIdleAnim)

func _on_change_idle_timeout() -> void:
	changeIdleAnimation()
	print("Changed idle Anim")
	$changeIdle.wait_time = randi_range(8, 36)
	$changeIdle.start()

signal clickNextString
var clickToTalk = false

var regSpeed = 0.025
var speed = 0.025
@onready var labelPrefab = $Label3D

var nextz = 0
func talk(str: String, forcedY = false):
	print("talked")
	var newLabel: Label3D = labelPrefab.duplicate()
	
	newLabel.text = str
	if forcedY:
		newLabel.position = Vector3(randf_range(-0.1, 0.1), 0.1, 0.000001*nextz)
	else:
		newLabel.position = Vector3(randf_range(-0.1, 0.1), randf_range(0.1, 0.15), 0.000001*nextz)
	nextz += 1
	newLabel.visible = true
	newLabel.scale = Vector3.ZERO
	add_child(newLabel)
	
	var newPosTween = create_tween()
	newPosTween.tween_property(newLabel, "position", newLabel.position + Vector3(0, 0.1, 0), 3)
	var newScaleTween = create_tween()
	newScaleTween.tween_property(newLabel, "scale", Vector3(0.1,0.1,0.1), 0.1)
	newScaleTween.play()
	newPosTween.play()
	await newPosTween.finished
	newScaleTween = create_tween()
	newScaleTween.tween_property(newLabel, "scale", Vector3.ZERO, 0.1)
	await newScaleTween.finished
	newLabel.queue_free()

func oldTextSet(str: String):
	if textQueue.size() == 0:
		textQueue.append(str)
		
		while(textQueue.size()>0):
			speed = regSpeed
			var word = textQueue[0]
			var stringLength = 0
			while(stringLength != word.length()):
				stringLength += 1
				talkingLabel.text = word.substr(0, stringLength)
				await get_tree().create_timer(speed).timeout
			if clickToTalk:
				await clickNextString
			else:
				await get_tree().create_timer(1).timeout
			while talkingLabel.text != "":
				talkingLabel.text = talkingLabel.text.substr(0, talkingLabel.text.length() - 1)
				await get_tree().create_timer(0.001).timeout
			
			textQueue.pop_front()
		
		finishedTalking.emit()
	else:
		textQueue.append(str)

func shootPlayer():
	$changeIdle.stop()
	
	Anims.play("win")
	await get_tree().create_timer(2.25).timeout
	$"blaster-b/OmniLight3D".visible = true

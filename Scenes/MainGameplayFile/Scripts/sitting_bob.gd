extends Node3D

@onready var talkingLabel = $Label3D
@onready var Anims = $AnimationPlayer
var idleAnims = ["idle", "sitting1"]
var distractionAnims = ["distracted", "distracted2", "distracted3"]

var currentIdleAnim: String

var textQueue: Array[String]

signal finishedTalking

func distract():
	Anims.stop()
	var randDistraction = randi_range(0, distractionAnims.size() - 1)
	Anims.play(distractionAnims[randDistraction])
	await Anims.animation_finished or Anims.animation_changed

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
	if currentAnim != currentIdleAnim:
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

func talk(str: String):
	if textQueue.size() == 0:
		textQueue.append(str)
		
		while(textQueue.size()>0):
			var word = textQueue[0]
			var stringLength = 0
			while(stringLength != word.length()):
				stringLength += 1
				talkingLabel.text = word.substr(0, stringLength)
				await get_tree().create_timer(0.025).timeout
			await get_tree().create_timer(3).timeout
			while talkingLabel.text != "":
				talkingLabel.text = talkingLabel.text.substr(0, talkingLabel.text.length() - 1)
				await get_tree().create_timer(0.01).timeout
			
			textQueue.pop_front()
		
		finishedTalking.emit()
	else:
		if textQueue.size() >= 3:
			textQueue.pop_back()
		textQueue.append(str)

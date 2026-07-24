extends Node3D

@onready var Anims = $AnimationPlayer
var idleAnims = ["idle", "sitting1"]
var distractionAnims = ["distracted", "distracted2", "distracted3"]

var currentIdleAnim: String

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

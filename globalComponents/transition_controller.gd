extends CanvasLayer

func ChangeScene(nextScenePath):
	$AnimationPlayer.stop()
	
	$AnimationPlayer.play("transitionIn")
	await  $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(nextScenePath)
	$AnimationPlayer.play("transitionOut")

func animationIn():
	$AnimationPlayer.play("transitionIn")
	await $AnimationPlayer.animation_finished

func animationOut():
	$AnimationPlayer.play("transitionOut")
	await  $AnimationPlayer.animation_finished

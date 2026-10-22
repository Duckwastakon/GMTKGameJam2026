extends CanvasLayer

func ChangeScene(nextScenePath):
	$AnimationPlayer.stop()
	
	$AnimationPlayer.play("suddenIn")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(nextScenePath)
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("fadeOut")

func animationIn():
	$AnimationPlayer.play("transitionIn")
	await $AnimationPlayer.animation_finished

func animationOut():
	$AnimationPlayer.play("transitionOut")
	await  $AnimationPlayer.animation_finished

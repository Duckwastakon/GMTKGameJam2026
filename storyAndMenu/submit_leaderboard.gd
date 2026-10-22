extends CanvasLayer

@onready var httpRequest = $Control/background/leaderboardSend
@onready var usernameInput = $Control/background/username

func activ(score):
	self.visible = true
	$Control/background/title2.text = "Round: " + str(score)

func submitScore():
	$Control/background/close.disabled = true
	$Control/background/submit.disabled = true
	$Control/background/submit.modulate = Color(0.224, 0.224, 0.224, 1.0)
	$Control/background/close.modulate = Color(0.224, 0.224, 0.224, 1.0)
	
	var username = usernameInput.text
	var round = randi_range(4, 10)#get_parent().round
	
	var body = JSON.stringify({"Username": username, "Round": round})
	
	httpRequest.request("https://godotdatabasebackend.onrender.com/submit", ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)

func _on_leaderboard_send_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	
	if(res["outcome"]):
		$Control/background/outcome.visible = true
		$Control/background/outcome.text = "Success"
		await get_tree().create_timer(1).timeout
		$Control/background/outcome.visible = false
		visible = false
		get_parent().finishedSaving()
	else:
		$Control/background/outcome.visible = true
		$Control/background/outcome.text = "something went wrong"
		await get_tree().create_timer(1).timeout
		$Control/background/outcome.visible = false
		$Control/background/submit.modulate = Color(0.533, 0.937, 0.635)
		$Control/background/close.modulate = Color(1.0, 0.463, 0.341)
		$Control/background/close.disabled = false
		$Control/background/submit.disabled = false

func _on_submit_button_up() -> void:
	submitScore()

func _on_close_button_up() -> void:
	visible = false
	get_parent().finishedSaving()

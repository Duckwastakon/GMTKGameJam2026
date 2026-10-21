extends Control

@onready var httpRequest = $leaderboardRequest
@onready var prefab = $oneValue
@onready var prefabContainer = $currentTopPlayers

func _ready() -> void:
	getLeaderboard()

func getLeaderboard():
	httpRequest.request("https://godotdatabasebackend.onrender.com/leaderboard")

func _on_leaderboard_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var res = JSON.parse_string(body.get_string_from_utf8())
	if res.has("err"):
		$title.text = "Failed to load leaderboard"
	else:
		$title.text = "Highest rounds"
		var i = 1
		for usersResults in res:
			var newVal = prefab.duplicate()
			newVal.visible = true
			newVal.get_child(1).text = str(i) + "."
			newVal.get_child(2).text = usersResults["name"]
			newVal.get_child(3).text = str(roundi(usersResults["round"]))
			prefabContainer.add_child(newVal)
			newVal.position = Vector2(0, 28*(i-1))
			i+=1

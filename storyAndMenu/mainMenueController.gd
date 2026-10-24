extends CanvasLayer

func _ready() -> void:
	for i: TextureButton in $Control/Node.get_children():
		i.connect("button_down", swing.bind(i))

func swing(btn: TextureButton):
	var startPos = btn.position
	var newTween = create_tween()
	newTween.set_ease(Tween.EASE_IN)
	newTween.tween_property(btn, "position", startPos + Vector2(0, 5), 0.05)
	newTween.play()
	
	await btn.button_up
	btn.disabled = true
	newTween.stop()
	newTween = create_tween()
	newTween.tween_property(btn, "position", startPos, 0.05)
	newTween.play()
	await newTween.finished
	btn.disabled = false

func _on_close_button_up() -> void:
	var newTween = create_tween()
	newTween.tween_property($Control/settings/background, "position", Vector2(344, 700), 0.2)
	newTween.play()
	AudioSystem.playSFX("res://sfx/click.ogg")
	
	await newTween.finished
	
	for b in $Control/Node.get_children():
		b.disabled = false

func _on_settings_button_up() -> void:
	for b in $Control/Node.get_children():
		b.disabled = true
	AudioSystem.playSFX("res://sfx/click.ogg")
	var newTween = create_tween()
	newTween.tween_property($Control/settings/background, "position", Vector2(344, 152), 0.2)
	newTween.play()

func _on_close_credits_button_up() -> void:
	var newTween = create_tween()
	newTween.tween_property($Control/Credits, "position", Vector2(344, 700), 0.2)
	newTween.play()
	AudioSystem.playSFX("res://sfx/click.ogg")
	
	await newTween.finished
	
	for b in $Control/Node.get_children():
		b.disabled = false


func _on_credits_button_up() -> void:
	for b in $Control/Node.get_children():
		b.disabled = true
	AudioSystem.playSFX("res://sfx/click.ogg")
	
	var newTween = create_tween()
	newTween.tween_property($Control/Credits, "position", Vector2(344, 140), 0.2)
	newTween.play()

func _on_story_mode_button_up() -> void:
	setNormals()
	Global.storyMode = true
	AudioSystem.playSFX("res://sfx/click.ogg")
	TransitionController.ChangeScene("res://storyAndMenu/storyStart.tscn")

func _on_infinite_mode_button_up() -> void:
	setNormals()
	Global.storyMode = false
	AudioSystem.playSFX("res://sfx/click.ogg")
	TransitionController.ChangeScene("res://gameplay/gameplay.tscn")

func setNormals():
	CardCalculator.cardPowers = {
	"Two": {
		"addMultiplier": 2,
		},
	"Three": {
		"addAmount": 3,
		},
	"Four": {
		"addAmount": 4,
		"addMultiplier": 0,
		},
	"Five": {
		"addAmount": 5,
		"addMultiplier": 0,
		},
	"Six": {
		"addAmount": 6,
		"addMultiplier": 0,
		},
	"Seven": {
		"addAmount": 7,
		"addMultiplier": 0,
		},
	"Eight": {
		"addAmount": 8,
		"addMultiplier": 0,
		},
	"Nine": {
		"addAmount": 9,
		"addMultiplier": 0,
		},
	"Ten": {
		"addAmount": 10,
		"addMultiplier": 0,
		},
	"Jack": {
		"addAmount": 10,
		"addMultiplier": 0,
		},
	"Queen": {
		"addAmount": 10,
		"addMultiplier": 0,
		},
	"King": {
		"addAmount": 10,
		"addMultiplier": 0,
		},
	"Ace": {
		"addAmount": 10,
		"addMultiplier": 1,
		},
	}
	CardCalculator.symbolPowers = {
	"Hearts": {
		"addAmount": 0,
		"addMultiplier": 0,
	},
	"Diamonds": {
		"addAmount": 0,
		"addMultiplier": 0,
	},
	"Clubs": {
		"addAmount": 0,
		"addMultiplier": 0,
	},
	"Spades": {
		"addAmount": 0,
		"addMultiplier": 0,
	},
	}
	CardCalculator.extraFunctions = {
	0: {
		
	},
	1:{
		
	}
}

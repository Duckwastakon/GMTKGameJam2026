extends CanvasLayer
@onready var countdown_label: Label = $CountdownLabel
@onready var ending: Node3D = $".."

var time_remaining: float = 60.0  # starting time in seconds
var counting_down = true
signal countdownFinished
signal countdownStarted

func _ready():
	time_remaining = 29
	ending.stopTimer.connect(_on_stopTimer)
	countdown_label.visible = false
	await get_tree().create_timer(13.0).timeout
	countdownStarted.emit() 
	countdown_label.visible = true
	counting_down = true

func _process(delta):
	if counting_down:
		time_remaining -= delta
		if time_remaining <= 0:
			time_remaining = 0
			counting_down = false
			on_countdown_finished()
		update_display()

func update_display():
	var minutes = int(time_remaining) / 60
	var seconds = int(time_remaining) % 60
	countdown_label.text = "%02d:%02d" % [minutes, seconds]

func on_countdown_finished():
	countdownFinished.emit() 

func _on_stopTimer():
	time_remaining =  1200

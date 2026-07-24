extends Control

@export var mainController: Node3D
var timeBeforePayment: int = 0
var basePaymentAmount: int = int(Global.cash / 15)

var fullRideTime = 150

func _ready() -> void:
	var finishTween = create_tween()
	finishTween.tween_property($background/fillIn, "scale", Vector2(1,1), fullRideTime)
	finishTween.play()
	if mainController:
		$cashPaymentTimer.start()
		var nextPaymentTime = 10 + randi_range(-3, 3)
		var nextPaymentAmount = int(basePaymentAmount * randf_range(0.9, 1.1))
		
		$paymentInfo.text = "next payment: " + str(nextPaymentAmount) + "$"
		print(nextPaymentAmount)
		while(nextPaymentTime + 10 < fullRideTime):
			await $cashPaymentTimer.timeout
			
			nextPaymentTime -= 1
			if mainController.debt <= 0:
				$blinkingTimer.visible = true
				$blinkingTimer.text = str(nextPaymentTime)
				await get_tree().create_timer(0.5).timeout
				$blinkingTimer.visible = false
			
			if nextPaymentTime <= 0:
				if Global.cash<nextPaymentAmount:
					nextPaymentAmount -= Global.cash
					Global.addCash(-Global.cash)
					addDebt(nextPaymentAmount)
				else:
					Global.addCash(-nextPaymentAmount)
					$blinkingTimer.text = "-$" + str(nextPaymentAmount)
					$blinkingTimer.visible = true
				
				nextPaymentTime = 10 + randi_range(-3, 3)
				nextPaymentAmount = int(basePaymentAmount * randf_range(0.9, 1.1))
				$paymentInfo.text = "next payment: " + str(nextPaymentAmount) + "$"
		

func addDebt(amt: int):
	mainController.debt += amt
	
	$blinkingTimer.text = "Debt: $" + str(mainController.debt)
	$blinkingTimer.visible = true
	$background.visible = false
	$paymentInfo.visible = false

func _on_cash_payment_timer_timeout() -> void:
	fullRideTime -= 1
	
	if fullRideTime <= 0:
		print("reached destination")
		mainController.reachEndSignal.emit()
	
	if mainController.debt > 0:
		$blinkingTimer.text = "Debt: $" + str(mainController.debt)
		$blinkingTimer.visible = true
		$background.visible = false
		$paymentInfo.visible = false
	else:
		$background.visible = true
		$paymentInfo.visible = true
	

extends Control

@export var mainController: Node3D
var timeBeforePayment: int = 0
var basePaymentAmount: int = int(Global.cash / 6)

var startRideTime = 150
var fullRideTime = 150

func setNextPayoutBar(extra: int):
	var xPos = ($background.size.x/startRideTime)*(startRideTime - fullRideTime + extra)
	var newTween = create_tween()
	newTween.tween_property($background/nextPaymentIndicator, "position", Vector2(xPos, -8), 0.1)
	newTween.play()
	$background/nextPaymentIndicator.visible = true

var lastPayment: int

func _ready() -> void:
	if mainController:
		var finishTween = create_tween()
		finishTween.tween_property($background/fillIn, "scale", Vector2(1,1), fullRideTime)
		finishTween.play()
		
		await mainController.finishTutorial
		finishTween.stop()
		
		$background/fillIn.scale = Vector2(0, 1)
		finishTween = create_tween()
		finishTween.tween_property($background/fillIn, "scale", Vector2(1,1), fullRideTime)
		finishTween.play()
		$cashPaymentTimer.start()
		var nextPaymentTime = 30 + randi_range(-3, 3)
		var nextPaymentAmount
		
		if basePaymentAmount < 50 * pow(5, Global.round - 1):
			nextPaymentAmount = int(50 * pow(5, Global.round - 1) * randf_range(0.9, 1.1))
		else:
			nextPaymentAmount = int(basePaymentAmount * randf_range(0.9, 1.1))
		
		$paymentInfo.text = "next payment: " + str(nextPaymentAmount) + "$"
		setNextPayoutBar(nextPaymentTime)
		while(nextPaymentTime + 10 < fullRideTime):
			await $cashPaymentTimer.timeout
			
			nextPaymentTime -= 1
			
			if mainController.debt == 0:
				$blinkingTimer.visible = false
				$background.visible = true
				$paymentInfo.visible = true
			
			if nextPaymentTime <= 0:
				if Global.cash<nextPaymentAmount:
					nextPaymentAmount -= Global.cash
					Global.addCash(-Global.cash)
					addDebt(nextPaymentAmount)
					$"../../../sounds/coin".play() #money lost sounds - Niko
				else:
					Global.addCash(-nextPaymentAmount)
					$blinkingTimer.text = "-$" + str(nextPaymentAmount)
					$blinkingTimer.visible = true
					$background.visible = false
					$paymentInfo.visible = false
					$"../../../sounds/coin".play() #money lost sounds - Niko
				
				nextPaymentTime = 10 + randi_range(-3, 3)
				basePaymentAmount = int(basePaymentAmount * randf_range(0.9, 1.1))
				$paymentInfo.text = "next payment: " + str(nextPaymentAmount) + "$"
				setNextPayoutBar(nextPaymentTime)
		await $cashPaymentTimer.timeout
		
		nextPaymentAmount = int(basePaymentAmount * randf_range(0.9, 1.1))
		$paymentInfo.text = "next payment: " + str(nextPaymentAmount) + "$"
		
		var xPos = (480)
		var newTween = create_tween()
		newTween.tween_property($background/nextPaymentIndicator, "position", Vector2(xPos, -8), 0.1)
		newTween.play()
		$background/nextPaymentIndicator.visible = true
		
		lastPayment = nextPaymentAmount
		
		while (mainController.debt > 0 and fullRideTime > 2):
			await $cashPaymentTimer.timeout
		
		if mainController.debt == 0:
			$blinkingTimer.visible = false
			$background.visible = true
			$paymentInfo.visible = true


func addDebt(amt: int):
	mainController.debt += amt
	
	$blinkingTimer.text = "Debt: $" + str(mainController.debt)
	$blinkingTimer.visible = true
	$background.visible = false
	$paymentInfo.visible = false

func _on_cash_payment_timer_timeout() -> void:
	fullRideTime -= 1
	if fullRideTime <= 0:
		$cashPaymentTimer.stop()
		if Global.cash<lastPayment:
			lastPayment -= Global.cash
			Global.addCash(-Global.cash)
			addDebt(lastPayment)
			$"../../../sounds/coin".play() #money lost sounds - Niko
		else:
			Global.addCash(-lastPayment)
			$blinkingTimer.text = "-$" + str(lastPayment)
			$blinkingTimer.visible = true
			$background.visible = false
			$paymentInfo.visible = false
			$"../../../sounds/coin".play() #money lost sounds - Niko
		await get_tree().create_timer(0.5).timeout
		while(mainController.debt > 0):
			await get_tree().create_timer(1).timeout
		$blinkingTimer.text = "Destination reached"
		mainController.reachEndSignal.emit()
		
		return
	
	if mainController.debt > 0:
		$blinkingTimer.text = "Debt: $" + str(mainController.debt)
		$blinkingTimer.visible = true
		$background.visible = false
		$paymentInfo.visible = false
	else:
		$background.visible = true
		$paymentInfo.visible = true

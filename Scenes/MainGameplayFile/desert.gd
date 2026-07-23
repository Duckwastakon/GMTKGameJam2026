extends Node3D

@onready var area: Area3D = $interact_area_ticket
@onready var ticket: Label3D = $interact_area_ticket/Label3D

func _ready() -> void:
	$interact_area_ticket/Label3D.visible = false
	ticket.set_text('Press e to interract')
	
func _process(delta):
	if Input.is_action_just_pressed('interract'):
		ticket.set_text('Shoot..Im missing 10 bucks.. maybe i should look around')
		ticket.visible = true
		await get_tree().create_timer(3.0).timeout
		ticket.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "moving_character":  # or check body.is_in_group("player")
		$interact_area_ticket/Label3D.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "moving_character":
		$interact_area_ticket/Label3D.visible = false
		

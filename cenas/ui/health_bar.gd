extends Control

@onready var fill_max = $ColorRect.size.x
var fill_amount : int

func update_healthbar(health, max_health):
	fill_amount = (int(health) / max_health) * fill_max
	$ColorRect.size.x = fill_amount

extends Control

@onready var transition = $Transition


func _on_play_pressed():
	transition.transition()
	await transition.on_transition_finished
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_quit_pressed():
	get_tree().quit()


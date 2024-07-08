extends Control

@onready var animation = $AnimationPlayer

func _ready():
	animation.play("RESET")

func game_over():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


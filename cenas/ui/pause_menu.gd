extends Control

func _ready():
	self.hide()
	$AnimationPlayer.play("RESET")

func resume():
	self.hide()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	self.show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func test():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	test()

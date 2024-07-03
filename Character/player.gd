extends CharacterBody2D

@export var speed = 200
@export var jump_speed = -300

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked = false
var direction = Vector2.ZERO 

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed

	direction = Input.get_vector("left", "right","up","down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	update_animation()
	update_direction()

func update_animation():
	if not animation_locked:
		if not is_on_floor():
			if velocity.y < 0:
				animated_sprite.play("jump")
		else:
			if direction.x != 0:
				animated_sprite.play("run")
			elif direction.x == 0:
				animated_sprite.play("idle")
			
func update_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

extends CharacterBody2D


@export var speed = 200
@export var jump_speed = -200
@export var double_jump = -150

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped = false
var animation_locked = false
var direction = Vector2.ZERO 

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		has_double_jumped = false

	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
		elif not has_double_jumped:
			velocity.y = double_jump
			has_double_jumped = true

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
		if direction.x != 0:
			animated_sprite.play("run")
		elif direction.x == 0:
			animated_sprite.play("idle")
			
func update_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true


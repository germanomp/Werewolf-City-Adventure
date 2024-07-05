@icon("res://art/free-villagers-sprite-sheets-pixel-art/3 Man/Man.png")

extends CharacterBody2D

@onready var animation = $AnimationPlayer


var speed = 40

var gravity = 900 

var facing_right = true

func _ready():
	$AnimationPlayer.play("walk")

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
		
	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else: 
		speed = abs(speed) * -1
		

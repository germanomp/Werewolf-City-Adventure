@icon("res://art/Evil Wizard/Idle1.png")

extends CharacterBody2D

var speed = 60
var max_health = 10
var health 

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 

var facing_right = true

func _ready():
	$AnimationPlayer.play("run")
	health = max_health

func _physics_process(delta):
	
	if not is_on_floor:
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
		
func take_damage(damage):
		health -= damage
		
		get_node("HealthBar").update_healthbar(health, max_health)
		
		if health <= 0:
			queue_free()

func die():
	queue_free()

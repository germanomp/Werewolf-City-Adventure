@icon("res://art/Evil Wizard/Idle1.png")

extends CharacterBody2D

@onready var animation = $AnimationPlayer

var speed = 60
var max_health = 20
var health 

var gravity = 900 

var facing_right = true

func _ready():
	animation.play("run")
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
		animation.play("hurt")
		get_node("HealthBar").update_healthbar(health, max_health)
		
		if health <= 0:
			die()

func die():
	speed = 0
	animation.play("death")

func _on_attack_area_area_entered(area):
	animation.play("attack")
	if area.get_parent().is_in_group("player"):
		area.get_parent().take_damage(10)

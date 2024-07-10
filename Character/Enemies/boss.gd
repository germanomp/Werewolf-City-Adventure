@icon("res://art/Evil Wizard/Idle2.png")

extends CharacterBody2D

@onready var animation = $AnimationPlayer
@onready var health_bar = $HealthBar
@onready var ray_cast = $RayCast2D
@onready var player = $"../Player"
@onready var transition = $"../Transition"

var speed = 60
var max_health = 100
var health 
var gravity = 900 
var facing_right = true

var player_detected = null
var attack_range = 100 

func _ready():
	animation.play("move")
	health = max_health
	
func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not player_detected:
		patrol()
		
	move_and_slide()

func patrol():
	if not ray_cast.is_colliding() and is_on_floor():
		flip()
	velocity.x = speed

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
	
func post_dead():
	transition.transition()
	await transition.on_transition_finished
	get_tree().change_scene_to_file("res://game.tscn")

func _on_attack_area_area_entered(area):
	if area.get_parent().is_in_group("player"):
		animation.play("attack")

func attack():
	if player.has_method("take_damage"):
		player.take_damage(20)

func _on_attack_area_area_exited(area):
	patrol()

@icon("res://art/free-werewolf-sprite-sheets-pixel-art/Black_Werewolf/walk1.png")

extends CharacterBody2D

@export var speed = 200
@export var jump_speed = -400

@onready var animation = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D
@onready var health_bar = $"../Ui/HealthBar"
@onready var interact = $Interact
var interact_target = null

var gravity = 900
var animation_locked = false
var direction = Vector2.ZERO 

@export var attacking = false

var is_dead = false
var max_health = 100
var health = 0
var can_take_damage = true

signal health_changed(health)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()
		
	if interact_target and Input.is_action_just_pressed("interact"):
		interact_target.die()
		#interact_target.queue_free()
		interact_target = null

func _ready():
	health = max_health
	health_bar.value = health
	health_bar.max_value = max_health
	animation.connect("animation_finished", Callable(self, "_on_Animation_finished"))
	interact.connect("area_entered", Callable(self, "_on_interact_area_entered"))

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
	if not animation_locked and not attacking and not is_dead:
		if not is_on_floor():
			if velocity.y < 0:
				animation.play("jump")
		else:
			if direction.x != 0:
				animation.play("run")
			elif direction.x == 0:
				animation.play("idle")
			
func update_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
		$Hitbox.scale.x = abs($Hitbox.scale.x)
		$AttackArea.scale.x = abs($AttackArea.scale.x) 
	elif direction.x < 0:
		animated_sprite.flip_h = true
		$Hitbox.scale.x = abs($Hitbox.scale.x) * -1
		$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
		
func take_damage(damage : int):
	if can_take_damage:
		animation.play("hurt")
		iframes()
		health -= damage
		health_bar.value = health
		
		if health <= 0:
			die()

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true
	
func die():
	print("morreu")
	is_dead = true
	speed = 0
	animation.play("dead")

func attack():
	attacking = true
	animation.play("attack")

func _on_attack_area_area_entered(area):
	if area.get_parent().is_in_group("inimigos"):
		area.get_parent().take_damage(5)

func _on_interact_area_entered(area):
	if area.get_parent().is_in_group("interactions"):
		interact_target = area.get_parent()

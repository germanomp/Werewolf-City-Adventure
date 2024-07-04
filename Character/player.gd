@icon("res://art/free-werewolf-sprite-sheets-pixel-art/Black_Werewolf/walk1.png")

extends CharacterBody2D

const FRICTION: float = 0.15

@export var speed = 200
@export var jump_speed = -300

@onready var animation = $AnimationPlayer
@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked = false
var direction = Vector2.ZERO 

@export var attacking = false

var max_health = 5
var health = 0
var can_take_damage = true

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		attack()

func _ready():
	health = max_health
	animation.connect("animation_finished", Callable(self, "_on_Animation_finished"))

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
	
func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		var parent = area.get_parent()
		parent.queue_free()
	
	attacking = true
	animation.play("attack")

func update_animation():
	if not animation_locked and not attacking:
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
		iframes()
		health -= damage
		
		if health <= 0:
			die()

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true
	
func die():
	get_tree().reload_scene()

@icon("res://art/free-werewolf-sprite-sheets-pixel-art/Black_Werewolf/walk1.png")

extends CharacterBody2D

const FRICTION: float = 0.15

@export var max_hp: int = 4
@export var hp: int = 2
signal hp_changed(new_hp)

@export var speed = 200
@export var jump_speed = -300

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked = false
var direction = Vector2.ZERO 
var is_attacking = false

func _ready():
	animated_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
			
	if Input.is_action_just_pressed("attack"): 
		is_attacking = true
		animated_sprite.play("attack")

	direction = Input.get_vector("left", "right","up","down")
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	update_animation()
	update_direction()

func update_animation():
	if not animation_locked and not is_attacking:
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
		
func _on_AnimatedSprite2D_animation_finished():
	if animated_sprite.animation == "attack":
		is_attacking = false
		
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	self.hp -= dam
	if hp > 0:
		animated_sprite.play("hurt")
		velocity += dir * force
	else: 
		animated_sprite.play("dead")
		velocity += dir * force * 2
	

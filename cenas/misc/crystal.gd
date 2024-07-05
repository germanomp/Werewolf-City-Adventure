@icon("res://art/Crystal_Animation/Red/red_crystal_0000.png")

extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var health = 1

func _ready():
	$AnimatedSprite2D.play("idle")

func take_damage(damage):
		health -= damage
		
		if health <= 0:
			queue_free()

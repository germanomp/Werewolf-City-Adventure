@icon("res://art/Foozle_2DTR0001_Pixel_Trap_Pack/Fire Trap/Fire Trap - Level 1.png")

extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation = $AnimationPlayer

func _on_area_entered(area):
	animation.play("attack")

func _on_attack_area_area_entered(area):
	if area.get_parent().is_in_group("player"):
		area.get_parent().take_damage(20)

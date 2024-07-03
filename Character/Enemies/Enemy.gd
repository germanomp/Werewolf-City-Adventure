@icon("res://art/Evil Wizard/Idle1.png")

extends CharacterBody2D

@export var max_hp: int = 4
@export var hp: int = 2

func take_damage(dam: int, dir: Vector2, force: int) -> void:
	self.hp -= dam
	if hp <= 0:
		queue_free()

@icon("res://art/book.png")

extends Area2D

signal book_recovered

func die():
	emit_signal("book_recovered", self)
	queue_free()

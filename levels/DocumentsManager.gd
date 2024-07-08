extends Node

var books = []
@onready var contador = $"../Ui/Contador"

func _ready():
	for child in get_children():
		if child.is_in_group("interactions"):
			books.append(child)
			child.connect("book_recovered", Callable(self, "_on_book_recovered"))
			
	_update_book_counter()

func _on_book_recovered(book):
	books.erase(book)
	_update_book_counter()
	if books.size() == 0:
		_transition_to_next_scene()
		
func _transition_to_next_scene():
	get_tree().change_scene_to_file("res://levels/level_final.tscn")
	
func _update_book_counter():
	contador.text = "Documentos restantes: " + str(books.size())

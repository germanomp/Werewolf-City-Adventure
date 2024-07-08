extends Node

var villagers = []
@onready var contador = $"../Ui/Contador"

func _ready():
	for child in get_children():
		if child.is_in_group("interactions"):
			villagers.append(child)
			child.connect("villager_rescued", Callable(self, "_on_villager_rescued"))
	
	_update_villager_counter()

func _on_villager_rescued(villager):
	villagers.erase(villager)
	_update_villager_counter()
	if villagers.size() == 0:
		_transition_to_next_scene()

func _transition_to_next_scene():
	get_tree().change_scene_to_file("res://levels/level_2.tscn")

func _update_villager_counter():
	contador.text = "Aldeões restantes: " + str(villagers.size())

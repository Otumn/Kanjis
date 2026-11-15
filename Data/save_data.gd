class_name SaveData
extends Resource

@export var exercice_memory : Array[String]
@export var elements: Array[ElementData]

var memory_size: int = 3

func add_exercice(name:String):
	exercice_memory.push_front(name)
	exercice_memory.resize(memory_size)

func get_new_card() -> ElementData:
	return elements.pick_random()

class_name SaveData
extends Resource

@export var exercice_memory : Array[String]
@export var elements: Array[ElementData]

var exo_memory_size: int = 2

func add_exercice(name:String):
	exercice_memory.push_front(name)
	exercice_memory.resize(exo_memory_size)

func get_new_card() -> ElementData:
	return elements.pick_random()

func get_new_word_card() -> ElementData:
	return null

func get_new_kanji_card() -> ElementData:
	return null

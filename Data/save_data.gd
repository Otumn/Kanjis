class_name SaveData
extends Resource

@export var exercice_memory : Array[String]
@export var elements: Array[ElementData]
@export var last_trained: Array[int]

var word_elements : Array[ElementData]
var kanji_elements : Array[ElementData]
var exo_memory_size: int = 2
var trained_memory_size: int = 5
var days_diff_limit: int = 3

func get_new_card() -> ElementData:
	return get_relevant_card_among(elements)

func get_new_word_card() -> ElementData:
	if word_elements.is_empty():
		for e in elements:
			if e.is_word:
				word_elements.append(e)
	return word_elements.pick_random()

func get_new_kanji_card() -> ElementData:
	if kanji_elements.is_empty():
		for e in elements:
			if !e.is_word:
				kanji_elements.append(e)
	return kanji_elements.pick_random()

func get_relevant_card_among(cards:Array[ElementData]) -> ElementData:
	var date = Time.get_datetime_dict_from_system()
	var day = date["day"]
	var month = date["month"]
	var year = date["year"]
	var possibles:Array[ElementData]
	
	for c in cards:
		var days_diff:int = 0
		var month_diff:int = 0
		var year_diff:int = 0
		if last_trained.has(c.id):
			continue
		
		year_diff = abs(c.last_seen_year - year)
		if year_diff != 0: return c
		month_diff = abs(c.last_seen_month - month) * 30
		if month_diff != 0: return c
		days_diff = abs(c.last_seen_day - day)
		if days_diff > days_diff_limit: return c
		
		if possibles.size() < 5: possibles.append(c)
	if !possibles.is_empty():
		return possibles.pick_random()
	
	return cards.pick_random()

func add_trained_card(card:ElementData):
	var date = Time.get_datetime_dict_from_system()
	last_trained.push_front(card.id)
	last_trained.resize(trained_memory_size)

func add_exercice(name:String):
	exercice_memory.push_front(name)
	exercice_memory.resize(exo_memory_size)

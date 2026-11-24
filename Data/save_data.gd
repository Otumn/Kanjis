class_name SaveData
extends Resource

@export var elements: Array[ElementData]
@export var last_trained: Array[int]
@export var exercice_memory : Array[String]

var general_elements: Array[int]
var word_elements: Array[int]
var kanji_elements: Array[int]
var exo_memory_size: int = 2
var trained_memory_size: int = 5
var days_diff_limit: int = 3
var need_general_list_update: bool = false
var need_word_list_update: bool = false
var need_kanji_list_update: bool = false

func get_new_card(exclude:Array[int] = [-1], only_not_trained:bool = true) -> int:
	if general_elements.is_empty() || need_general_list_update:
		general_elements.clear()
		for e in elements.size():
			general_elements.append(e)
	return get_relevant_card_among(general_elements, exclude, only_not_trained)

func get_new_word_card(exclude:Array[int] = [-1], only_not_trained:bool = true) -> int:
	if word_elements.is_empty() || need_word_list_update:
		word_elements.clear()
		for e in elements:
			if e.is_word:
				word_elements.append(e.id)
		need_word_list_update = false
	return get_relevant_card_among(word_elements, exclude, only_not_trained)

func get_new_kanji_card(exclude:Array[int] = [-1], only_not_trained:bool = true) -> int:
	if kanji_elements.is_empty() || need_kanji_list_update:
		kanji_elements.clear()
		for e in elements:
			if !e.is_word:
				kanji_elements.append(e.id)
		need_kanji_list_update = false
	return get_relevant_card_among(kanji_elements, exclude, only_not_trained)

func get_relevant_card_among(cards:Array[int], exclude:Array[int] = [-1], only_not_trained:bool = true) -> int:
	var date = Time.get_datetime_dict_from_system()
	var day = date["day"]
	var month = date["month"]
	var year = date["year"]
	var possibles:Array[int]
	
	for c in cards:
		var days_diff:int = 0
		var month_diff:int = 0
		var year_diff:int = 0
		
		if exclude.has(c):
			continue
		
		if !last_trained.has(c) && only_not_trained:
			year_diff = abs(elements[c].last_seen_year - year)
			if year_diff != 0: return c
			month_diff = abs(elements[c].last_seen_month - month) * 30
			if month_diff != 0: return c
			days_diff = abs(elements[c].last_seen_day - day)
			if days_diff > days_diff_limit: return c
		
		if possibles.size() < 5: possibles.append(c)
	if !possibles.is_empty():
		return possibles.pick_random()
	
	return cards.pick_random()

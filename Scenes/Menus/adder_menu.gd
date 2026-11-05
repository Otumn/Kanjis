extends BaseMenu

@onready var app_mode_button: AppModeButton = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/AppModeButton
@onready var word_adding_parent: VBoxContainer = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/WordAddingParent
@onready var kanji_adding_parent: VBoxContainer = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/KanjiAddingParent

## WORD INPUTS
@onready var wrd_input_jap: LineEdit = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/WordAddingParent/Wrd_Input_Jap
@onready var wrd_input_kana: LineEdit = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/WordAddingParent/Wrd_Input_Kana
@onready var wrd_input_translation: LineEdit = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/WordAddingParent/Wrd_Input_Translation

## KANJI INPUTS

@onready var knj_input_jap: LineEdit = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/KanjiAddingParent/Knj_Input_Jap
@onready var knj_input_kun: LineEdit = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/KanjiAddingParent/Knj_Input_Kun
@onready var knj_input_on: LineEdit = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/KanjiAddingParent/Knj_Input_On
@onready var knj_input_translation: LineEdit = $VBoxContainer/Container/ScrollContainer/MarginContainer/Content/DoubleParent/KanjiAddingParent/Knj_Input_Translation

const valid_separators:Array[String] = [",", " ", "、"]

func menu_selected():
	switch_menus(app_mode_button.word_mode)

func switch_menus(word:bool):
	word_adding_parent.visible = word
	kanji_adding_parent.visible = !word

func _on_app_mode_button_mode_changed(word: bool) -> void:
	switch_menus(word)

func _on_btn_validate_button_down() -> void:
	create_element()

func create_element():
	if app_mode_button.word_mode:
		if wrd_input_jap.text.is_empty(): 
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Missing info", 
			"Please enter a valid word to add.")
			return
		
		## TODO : Need a check here for duplicates
		
		if wrd_input_kana.text.is_empty(): 
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Missing info", 
			"Please enter a valid kana version to the word.")
			return
		
		if wrd_input_translation.text.is_empty(): 
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Missing info", 
			"Please enter a valid translation to the word.")
			return
		
		var new_card:ElementData = ElementData.new()
		new_card.id = SaveLogic.get_next_element_id()
		new_card.is_word = true
		new_card.base_writing = wrd_input_jap.text
		new_card.kanas = wrd_input_kana.text
		new_card.translation = wrd_input_translation.text
		var date = Time.get_datetime_dict_from_system()
		new_card.last_seen_day = date["day"]
		new_card.last_seen_month = date["month"]
		new_card.last_seen_year = date["year"]
		
		SaveLogic.save_new_element(new_card)
		SaveLogic.save_data()
		
		clear_fields()
	else:
		if knj_input_jap.text.is_empty(): 
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Missing info", 
			"Please enter a valid word to add.")
			return
		
		## TODO : Need a check here for duplicates
		
		if knj_input_kun.text.is_empty(): 
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Missing info", 
			"Please enter valid kunyomi writtings.")
			return
		
		if !check_text_separators(knj_input_kun.text):
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Wrong syntax", 
			"Please use only one separator in kunyomi: 、, or space")
			return
		
		if knj_input_on.text.is_empty(): 
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Missing info", 
			"Please enter valid onyomi writtings.")
			return
		
		if !check_text_separators(knj_input_on.text):
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Wrong syntax", 
			"Please use only one separator in onyomi: 、, or space")
			return
		
		if knj_input_translation.text.is_empty(): 
			PopupLogic.pop_info(PopupLogic.pop_type.INFO, 
			"Missing info", 
			"Please enter a valid translation to the word.")
			return
		
		var new_card:ElementData = ElementData.new()
		new_card.id = SaveLogic.get_next_element_id()
		new_card.is_word = false
		new_card.base_writing = knj_input_jap.text
		new_card.kunyomi = separate_input(knj_input_kun.text)
		new_card.onyomi = separate_input(knj_input_on.text)
		new_card.translation = knj_input_translation.text
		var date = Time.get_datetime_dict_from_system()
		new_card.last_seen_day = date["day"]
		new_card.last_seen_month = date["month"]
		new_card.last_seen_year = date["year"]
		
		SaveLogic.save_new_element(new_card)
		SaveLogic.save_data()
		
		clear_fields()

func clear_fields():
	## WORD
	wrd_input_jap.text = ""
	wrd_input_kana.text = ""
	wrd_input_translation.text = ""
	
	## KANJI
	knj_input_jap.text = ""
	knj_input_kun.text = ""
	knj_input_on.text = ""
	knj_input_translation.text = ""

func check_text_separators(text:String) -> bool:
	if text.contains(valid_separators[0]):
		return !(text.contains(valid_separators[1]) || text.contains(valid_separators[2]))
	if text.contains(valid_separators[1]):
		return !(text.contains(valid_separators[0]) || text.contains(valid_separators[2]))
	if text.contains(valid_separators[2]):
		return !(text.contains(valid_separators[0]) || text.contains(valid_separators[1]))
	return false

func separate_input(text:String) -> PackedStringArray:
	var separator:String
	if text.contains(valid_separators[0]): separator = valid_separators[0]
	if text.contains(valid_separators[1]): separator = valid_separators[1]
	if text.contains(valid_separators[2]): separator = valid_separators[2]
	
	var array = text.split(separator, false)
	
	return array

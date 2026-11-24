extends BaseExercice

@onready var label_base_writing: Label = $VBoxContainer/Label_BaseWriting
@onready var label_clue: Label = $VBoxContainer/Btn_Answer/VBoxContainer/Label_Clue
@onready var label_translation: Label = $VBoxContainer/Btn_Answer/VBoxContainer/Label_Translation
@onready var view_timer: Timer = $ViewTimer

@export var normal_view_time:float = 0.75
@export var normal_bait_number:float = 3
@export var normal_total_cycles:float = 3

@export var mastered_view_time:float = 0.5
@export var mastered_bait_numbers:float = 5
@export var mastered_total_cycles:float = 1

var current_shown_index:int = -1
var current_answer_index:int = -1
var current_cycle:int = 0
var shown_cards:Array[int]

func setup_exercice():
	select_tested_card()
	var card:ElementData = SaveLogic.data.elements[tested_card]
	shown_cards.clear()
	current_shown_index = -1
	current_cycle = 0
	
	view_timer.wait_time = normal_view_time if card.mastery < 1 else mastered_view_time
	
	var excluded:Array[int] = []
	for i in (normal_bait_number if card.mastery < 1 else mastered_bait_numbers):
			excluded.clear()
			excluded = shown_cards
			excluded.append(tested_card)
			if card.is_word:
				shown_cards.append(SaveLogic.data.get_new_word_card(excluded, false))
			else:
				shown_cards.append(SaveLogic.data.get_new_kanji_card(excluded, false))
			
	shown_cards.insert((randi() % shown_cards.size()), tested_card)
	print(str(tested_card))
	print(str(shown_cards))
	cycle_through_cards()

func cycle_through_cards():
	print("New view!")
	current_shown_index += 1
	if current_shown_index >= shown_cards.size():
		current_cycle += 1 
		if current_cycle >= (normal_total_cycles if SaveLogic.data.elements[tested_card].mastery < 1 else mastered_total_cycles):
			fail_exercice()
			return
		else:
			print("New cycle!")
			current_shown_index = 0
	var displayed_card = SaveLogic.data.elements[shown_cards[current_shown_index]]
	current_answer_index = shown_cards[current_shown_index]
	print(str(current_answer_index))
	label_clue.text = displayed_card.get_sorted_clue()
	label_translation.text = displayed_card.translation
	view_timer.start()

func check_answer():
	if current_answer_index == tested_card:
		validate_exercice()
	else:
		fail_exercice()
	view_timer.stop()

func _on_btn_answer_button_down() -> void:
	check_answer()

func _on_view_timer_timeout() -> void:
	cycle_through_cards()

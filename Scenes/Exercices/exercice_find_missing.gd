extends BaseExercice

@onready var label_main_writing: Label = $VBoxContainer/Label_MainWriting
@onready var label_clue: Label = $VBoxContainer/Label_Clue
@onready var input_answer: LineEdit = $VBoxContainer/Input_Answer
@onready var label_good_answer: Label = $ResultsParent/SuccessParent/Label_GoodAnswer
@onready var label_wrong_answer: Label = $ResultsParent/FailureParent/Label_WrongAnswer
@onready var bar_mastery: ProgressBar = $VBoxContainer/Bar_Mastery

var expected_answer:String = ""

func setup_exercice():
	select_tested_card()
	var card = SaveLogic.data.elements[tested_card]
	
	input_answer.text = ""
	label_clue.visible = card.mastery < 1
	
	label_main_writing.text = card.base_writing
	if card.is_word:
		var choice = randi() % 2
		if choice == 0:#find the kana
			label_clue.text = card.translation
			expected_answer = card.kanas
		else:#find the translation
			label_clue.text = card.kanas
			expected_answer = card.translation
	else:
		var choice = randi() % 3
		if choice == 0:#find kunyomis
			label_clue.text = card.translation + "\n" + card.get_full_onyomi()
			expected_answer = card.get_full_kunyomi()
		elif choice == 1:#find onyomis
			label_clue.text = card.translation + "\n" + card.get_full_kunyomi()
			expected_answer = card.get_full_onyomi()
		elif choice == 2:#find translation
			label_clue.text = card.get_full_onyomi() + "\n" + card.get_full_onyomi()
			expected_answer = card.translation
		pass
	
	label_good_answer.text = expected_answer
	label_wrong_answer.text = expected_answer
	bar_mastery.value = card.mastery
	super.setup_exercice()

func _on_btn_validate_button_down() -> void:
	if input_answer.text == expected_answer:
		validate_exercice()
	else:
		fail_exercice()

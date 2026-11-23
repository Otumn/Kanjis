extends BaseExercice

@onready var label_translation: Label = $VBoxContainer/Label_Translation
@onready var pick_right_01: PickRightButton = $VBoxContainer/HBoxContainer/PickRight_01
@onready var pick_right_02: PickRightButton = $VBoxContainer/HBoxContainer/PickRight_02
@onready var pick_right_03: PickRightButton = $VBoxContainer/HBoxContainer/PickRight_03
@onready var label_good_answer: Label = $ResultsParent/SuccessParent/Label_GoodAnswer
@onready var label_wrong_answer: Label = $ResultsParent/FailureParent/Label_WrongAnswer

func _ready() -> void:
	pick_right_01.on_answer_chosen.connect(on_answer_selected)
	pick_right_02.on_answer_chosen.connect(on_answer_selected)
	pick_right_03.on_answer_chosen.connect(on_answer_selected)

func setup_exercice():
	select_tested_card()
	var card:ElementData = SaveLogic.data.elements[tested_card]
	
	pick_right_01.clear_button()
	pick_right_02.clear_button()
	pick_right_03.clear_button()
	
	label_translation.text = card.translation
	label_good_answer.text = card.base_writing
	label_wrong_answer.text = card.base_writing
	
	var choice:int = randi() % 3
	match choice:
		0:
			pick_right_01.display_card(tested_card)
		1:
			pick_right_02.display_card(tested_card)
		2:
			pick_right_03.display_card(tested_card)
	
	super.setup_exercice()

func on_answer_selected(index:int):
	if index == tested_card:
		validate_exercice()
	else:
		fail_exercice()

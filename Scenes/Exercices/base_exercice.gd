class_name BaseExercice
extends Control

signal on_exercice_setup
signal on_exercice_success
signal on_exercice_fail

@export var exercice_name:String = "Exercice"
@export var success_value: float = 0.1
@export var fail_value: float = 0.1
enum ExerciceType{WORD_AND_KANJI, WORD_ONLY, KANJI_ONLY}
@export var type: ExerciceType = ExerciceType.WORD_AND_KANJI

var tested_card:int

func setup_exercice():
	on_exercice_setup.emit()

func validate_exercice():
	SaveLogic.add_trained_card(tested_card)
	update_tested_card_mastery(success_value)
	on_exercice_success.emit()

func fail_exercice():
	SaveLogic.add_trained_card(tested_card)
	update_tested_card_mastery(-fail_value)
	on_exercice_fail.emit()

func select_tested_card():
	match type:
		ExerciceType.WORD_AND_KANJI:
			tested_card = SaveLogic.data.get_new_card()
		ExerciceType.WORD_ONLY:
			tested_card = SaveLogic.data.get_new_word_card()
		ExerciceType.KANJI_ONLY:
			tested_card = SaveLogic.data.get_new_kanji_card()

func update_tested_card_mastery(value:float):
	SaveLogic.data.elements[tested_card].mastery = clampf(SaveLogic.data.elements[tested_card].mastery + value, 0, 1)

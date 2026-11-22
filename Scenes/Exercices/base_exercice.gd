class_name BaseExercice
extends Control

signal on_exercice_setup
signal on_exercice_success
signal on_exercice_fail

@onready var success_parent: Control = $ResultsParent/SuccessParent
@onready var failure_parent: Control = $ResultsParent/FailureParent
@onready var result_timer: Timer = $ResultsParent/ResultTimer

@export var exercice_name:String = "Exercice"
@export var success_value: float = 0.1
@export var success_timer: float = 1.0
@export var fail_value: float = 0.1
@export var fail_timer:float = 3.0
enum ExerciceType{WORD_AND_KANJI, WORD_ONLY, KANJI_ONLY}
@export var type: ExerciceType = ExerciceType.WORD_AND_KANJI

var tested_card: int
var was_a_success: bool = false

func setup_exercice():
	success_parent.visible = false
	failure_parent.visible = false
	on_exercice_setup.emit()

func validate_exercice():
	print(exercice_name + " was successfull")
	SaveLogic.add_trained_card(tested_card)
	update_tested_card_mastery(success_value)
	was_a_success = true
	result_timer.wait_time = success_timer
	result_timer.start()
	success_parent.visible = true

func fail_exercice():
	print(exercice_name + " was failed")
	SaveLogic.add_trained_card(tested_card)
	update_tested_card_mastery(-fail_value)
	was_a_success = false
	result_timer.wait_time = fail_timer
	result_timer.start()
	failure_parent.visible = true

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

func _on_result_timer_timeout() -> void:
	success_parent.visible = false
	failure_parent.visible = false
	if was_a_success:
		on_exercice_success.emit()
	else:
		on_exercice_fail.emit()
